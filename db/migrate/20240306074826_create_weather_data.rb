class CreateWeatherData < ActiveRecord::Migration[7.1]
  def change
    create_table :weather_data do |t|
      t.string :weather_condition
      t.integer :trip_id
      t.datetime :timestamp
      t.float :temperature
      t.float :wind_speed
      t.string :wind_direction
      t.float :wave_height
      t.string :tide
      t.float :tide_level

      t.timestamps
    end
  end
end
