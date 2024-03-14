# frozen_string_literal: true

class ChageLongitudeColumn < ActiveRecord::Migration[7.1]
  def change
    rename_column :locations, :longtude, :longitude
  end
end
