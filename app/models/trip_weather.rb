# frozen_string_literal: true

class TripWeather < ApplicationRecord
  validates :trip_id, presence: true
  validates :weather_data_id, presence: true

  belongs_to :trip
  belongs_to :weather_data
end
