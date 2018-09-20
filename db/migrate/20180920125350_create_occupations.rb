class CreateOccupations < ActiveRecord::Migration[5.2]
  def change
    create_table :occupations do |t|
      t.belongs_to :jack, index: true
      t.belongs_to :trade, index: true
      t.boolean :master, null: false, default: false
      t.timestamps
    end
  end
end
