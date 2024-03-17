# frozen_string_literal: true

class ChangeFavoriteLocationNameToLocationName < ActiveRecord::Migration[7.1]
  def change
    rename_column :favorite_locations, :name, :location_name
  end
end
