class AddIndexToCastles < ActiveRecord::Migration[7.0]
  def change
    add_index :castles, :qid, unique: true
  end
end
