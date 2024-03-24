# frozen_string_literal: true

class RenameAirTemperture < ActiveRecord::Migration[7.1]
  def change
    rename_column :weather_data, :temperature, :air_temperature
  end
end
