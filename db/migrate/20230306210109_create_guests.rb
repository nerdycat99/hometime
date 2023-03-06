# frozen_string_literal: true

class CreateGuests < ActiveRecord::Migration[7.0]
  def change
    create_table :guests do |t|
      t.string :first_name
      t.string :last_name
      t.json :phone
      t.string :email, index: { unique: true }
      t.timestamps
    end
  end
end
