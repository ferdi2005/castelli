class CastlesController < ApplicationController
  def index
    @castles = Castle.where.not(latitude: nil, longitude: nil)
    @regioni = ["Marche",                                     
      "Lombardia",                                  
      "Piemonte",                                   
      "Liguria",                                    
      "Sicilia",                                    
      "Lazio",                                      
      "Campania",                                   
      "Basilicata",                                 
      "Abruzzo",                                    
      "Emilia-Romagna",                             
      "Puglia",                                     
      "Umbria",                                     
      "Toscana",                                    
      "Valle d'Aosta",                              
      "Friuli-Venezia Giulia",
      "Sardegna",
      "Molise",
      "Veneto",
      "Calabria",
      "Trentino-Alto Adige"]  
  end

  def show
    @castle = Castle.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @monument }
    end
  end
end
