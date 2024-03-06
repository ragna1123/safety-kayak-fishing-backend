class CreateTripReturns < ActiveRecord::Migration[7.1]
  def change
    create_table :trip_returns do |t|
      t.integer :trip_id, null: false
      t.datetime :return_time, null: false
      t.text :return_details, null: true

      t.timestamps
    end
    add_index :trip_returns, :trip_id
    add_foreign_key :trip_returns, :trips, column: :trip_id, on_delete: :cascade
  end
end
