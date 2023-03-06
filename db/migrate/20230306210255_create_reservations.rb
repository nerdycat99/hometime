# frozen_string_literal: true

class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.references :guest, null: false, foreign_key: true
      t.string :code, index: { unique: true }
      t.date :start_date
      t.date :end_date
      t.integer :security_price
      t.integer :payout_amount
      t.integer :total_paid
      t.integer :currency, null: false
      t.integer :status, null: false
      t.integer :adults
      t.integer :children
      t.integer :infants
      t.string :notes
      t.timestamps
    end
  end
end
