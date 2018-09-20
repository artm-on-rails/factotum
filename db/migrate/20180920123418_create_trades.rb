class CreateTrades < ActiveRecord::Migration[5.2]
  def change
    create_table :trades do |t|
      t.string :name, null: false, default: ""
      t.timestamps
    end
    add_index :trades, :name, unique: true
  end
end
