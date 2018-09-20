# frozen_string_literal: true

class DeviseCreateJacks < ActiveRecord::Migration[5.2]
  def change
    create_table :jacks do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      t.timestamps null: false
    end
    add_index :jacks, :email, unique: true
  end
end
