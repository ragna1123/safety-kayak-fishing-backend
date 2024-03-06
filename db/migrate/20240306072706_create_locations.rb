class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.decimal :latitude
      t.decimal :longtude

      t.timestamps
    end
  end
end
