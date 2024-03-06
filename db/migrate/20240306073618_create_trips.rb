class CreateTrips < ActiveRecord::Migration[7.1]
  def change
    create_table :trips do |t|
      t.integer :user_id
      t.integer :location_id
      t.datetime :departure_time
      t.datetime :estimated_return_time
      t.text :details
      t.integer :safety_score
      t.datetime :sunrise_time
      t.datetime :sunset_time

      t.timestamps
    end
  end
end
