# frozen_string_literal: true

class WeatherData < ApplicationRecord
  validates :time, presence: true
  validates :cloud_cover, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :humidity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :swell_direction, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 360 }
  validates :wave_direction, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 360 }
  validates :wind_wave_direction, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 360 }
  validates :wind_direction, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 360 }
end
