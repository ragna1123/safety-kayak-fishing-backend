class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.decimal :latitude, null: false
      t.decimal :longtude, null: false

      t.timestamps
    end
  end
end
