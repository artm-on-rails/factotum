class IndexOccupationsOnUniqueJackTrade < ActiveRecord::Migration[5.2]
  def change
    add_index :occupations, [:jack_id, :trade_id], unique: true
  end
end
