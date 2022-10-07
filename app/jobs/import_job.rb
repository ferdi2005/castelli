class ImportJob < ApplicationJob
  queue_as :default

  def normalize_value(value)
    if value.to_s == ""
      return nil
    elsif value.start_with?("_:")
      return nil
    else
      return value.to_s
    end
  end

  def perform
    endpoint = 'https://query.wikidata.org/sparql'
    sparql = 'SELECT DISTINCT ?item ?itemLabel ?itemDescription ?coords ?image ?sitelink ?commons ?regioneLabel ?unit ?unitLabel ?address
    
    WHERE {
      ?item p:P2186 ?wlmst .
      ?wlmst pq:P790 wd:Q85864317 .

      ?item wdt:P17 wd:Q38 . 
      ?item wdt:P131 ?unit .
      
      OPTIONAL {?item wdt:P625 ?coords. }
      OPTIONAL { ?item wdt:P373 ?commons. }
      OPTIONAL { ?item wdt:P18 ?image. }
      OPTIONAL { ?item wdt:P6375 ?address.}
      OPTIONAL {?sitelink schema:isPartOf <https://it.wikipedia.org/>;schema:about ?item. }

      VALUES ?typeRegion { wd:Q16110 wd:Q1710033 }.

      ?item wdt:P131* ?regione.
      ?regione wdt:P31 ?typeRegion.

      SERVICE wikibase:label { bd:serviceParam wikibase:language "it" }
      }'

    retcount = 0
    begin
      client = SPARQL::Client.new(endpoint, method: :get, headers: { 'User-Agent': 'WLM Castelli (https://github.com/ferdi2005/castelli) using Ruby SPARQL gem' })
      monuments = client.query(sparql)
    rescue => e
      retcount += 1
      if retcount < 5
        retry
      else
        Raven.capture_message("Impossibile eseguire il job di importazione per errore nella connessione a SPARQL: #{e}", level: 'fatal')
        return
      end
    end

    monuments_to_be_saved = []
    monuments.uniq.each do |monument|
      mon = {}

      mon[:qid] = normalize_value(monument[:item]).split('/')[4]

      latlongarray = normalize_value(monument[:coords]).try(:split, '(').try(:[], 1).try(:split, ')').try(:[], 0).try(:split, ' ')
      unless latlongarray.nil?
        lat = latlongarray[1]
        long = latlongarray[0]
        mon[:latitude] = BigDecimal(lat)
        mon[:longitude] = BigDecimal(long)
      else
        mon[:latitude] = nil
        mon[:longitude] = nil
      end

      mon[:label] = normalize_value(monument[:itemLabel])

      mon[:image] = normalize_value(monument[:image]).try(:split, 'Special:FilePath/').try(:[], 1)

      mon[:commons] = normalize_value(monument[:commons])

      mon[:description] = normalize_value(monument[:itemDescription])

      mon[:wikipedia] = normalize_value(monument[:sitelink])

      mon[:region] = normalize_value(monument[:regioneLabel])

      mon[:town] = normalize_value(monument[:unit]).split('/')[4]

      mon[:townqid] = normalize_value(monument[:unitLabel])

      mon[:address] = normalize_value(monument[:address])

      monuments_to_be_saved.reject! { |i| i[:qid] == mon[:qid] } # Elimina duplicati (salvando dunque l'ultimo che arriva) derivanti da dati con elementi duplicati

      monuments_to_be_saved.push(mon)
    end

    monuments_to_be_saved.uniq!

    monuments_to_be_saved.map! { |mon| mon.merge({created_at: DateTime.now, updated_at: DateTime.now})}

    Castle.upsert_all(monuments_to_be_saved, unique_by: :qid)

    # Cancella monumenti che non vengono più restituiti dalla query
    items_to_be_deleted = Castle.pluck(:qid).uniq - monuments_to_be_saved.pluck(:qid).uniq

    items_to_be_deleted.each { |item| Castle.find_by(qid: item).destroy }
  end
end