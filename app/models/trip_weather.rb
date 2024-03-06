class TripWeather < ApplicationRecord
  validates :trip_id, presence: true
  validates :weather_data, presence: true
end
