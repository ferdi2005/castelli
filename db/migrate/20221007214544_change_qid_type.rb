class ChangeQidType < ActiveRecord::Migration[7.0]
  def change
    change_column(:castles, :qid, :string)
  end
end
