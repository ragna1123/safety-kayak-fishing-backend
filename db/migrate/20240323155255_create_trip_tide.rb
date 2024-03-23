class CreateTripTide < ActiveRecord::Migration[7.1]
  def change
    create_table :trip_tides do |t|
      t.references :trip, null: false, foreign_key: true
      t.references :tide_data, null: false, foreign_key: true

      t.timestamps
    end
  end
end
