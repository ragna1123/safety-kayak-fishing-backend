class CreateWeatherData < ActiveRecord::Migration[7.1]
  def change
    create_table :weather_data do |t|
      t.string :weather_condition, null: false
      t.datetime :timestamp, null: false
      t.float :temperature, null: false
      t.float :wind_speed, null: false
      t.string :wind_direction, null: false
      t.float :wave_height, null: false
      t.string :tide, null: true
      t.float :tide_level, null: true

      t.timestamps
    end
    add_index :weather_data, :timestamp
  end
end
