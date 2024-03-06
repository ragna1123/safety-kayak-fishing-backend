class CreateTripReturns < ActiveRecord::Migration[7.1]
  def change
    create_table :trip_returns do |t|
      t.integer :trip_id
      t.datetime :return_time
      t.text :return_details

      t.timestamps
    end
  end
end
