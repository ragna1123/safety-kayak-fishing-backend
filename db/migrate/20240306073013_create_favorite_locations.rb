class CreateFavoriteLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :favorite_locations do |t|
      t.integer :user_id
      t.integer :location_id
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
