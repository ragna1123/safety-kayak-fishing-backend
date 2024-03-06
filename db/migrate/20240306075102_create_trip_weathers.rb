class CreateTripWeathers < ActiveRecord::Migration[7.1]
  def change
    create_table :trip_weathers do |t|
      t.integer :trip_id
      t.integer :weather_data_id

      t.timestamps
    end
  end
end
