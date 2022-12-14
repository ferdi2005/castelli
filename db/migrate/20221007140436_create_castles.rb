class CreateCastles < ActiveRecord::Migration[7.0]
  def change
    create_table :castles do |t|
      t.integer :qid
      t.string :label
      t.string :description
      t.decimal :latitude
      t.decimal :longitude
      t.string :image
      t.string :region
      t.string :town
      t.integer :townqid
      t.string :address
      t.string :wikipedia
      t.string :commons

      t.timestamps
    end
  end
end
