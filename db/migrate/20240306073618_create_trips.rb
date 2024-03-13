# frozen_string_literal: true

class CreateTrips < ActiveRecord::Migration[7.1]
  def change
    create_table :trips do |t|
      t.integer :user_id, null: false
      t.integer :location_id, null: false
      t.datetime :departure_time, null: false
      t.datetime :estimated_return_time, null: false
      t.text :details, null: true
      t.integer :safety_score, null: true
      t.datetime :sunrise_time, null: true
      t.datetime :sunset_time, null: true

      t.timestamps
    end
    add_index :trips, :user_id
    add_index :trips, :location_id
    add_foreign_key :trips, :users, column: :user_id, on_delete: :cascade
    add_foreign_key :trips, :locations, column: :location_id, on_delete: :cascade
  end
end
