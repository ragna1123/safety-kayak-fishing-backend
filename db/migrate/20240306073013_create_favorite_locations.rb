class CreateFavoriteLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :favorite_locations do |t|
      t.integer :user_id, null: false
      t.integer :location_id, null: false
      t.string :name, null: false
      t.string :description,  null: true

      t.timestamps
    end
    add_index :favorite_locations, :user_id
    add_index :favorite_locations, :location_id
    add_foreign_key :favorite_locations, :users, column: :user_id, on_delete: :cascade
    add_foreign_key :favorite_locations, :locations, column: :location_id, on_delete: :cascade
  end
end
