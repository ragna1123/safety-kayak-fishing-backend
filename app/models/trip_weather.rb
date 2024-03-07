# frozen_string_literal: true

class TripWeather < ApplicationRecord
  validates :trip_id, presence: true
  validates :weather_data_id, presence: true
end
