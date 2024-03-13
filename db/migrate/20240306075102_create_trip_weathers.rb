# frozen_string_literal: true

class CreateTripWeathers < ActiveRecord::Migration[7.1]
  def change
    create_table :trip_weathers do |t|
      t.integer :trip_id, null: false
      t.integer :weather_data_id, null: false

      t.timestamps
    end
    add_index :trip_weathers, :trip_id
    add_index :trip_weathers, :weather_data_id
    add_foreign_key :trip_weathers, :trips, column: :trip_id, on_delete: :cascade
    add_foreign_key :trip_weathers, :weather_data, column: :weather_data_id, on_delete: :cascade
  end
end
