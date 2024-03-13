# frozen_string_literal: true

class WeatherData < ApplicationRecord
  validates :weather_condition, presence: true
  validates :timestamp, presence: true
  validates :temperature, presence: true
  validates :wind_speed, presence: true
  validates :wind_direction, presence: true
  validates :wave_height, presence: true
  belongs_to :trip_weather
end
