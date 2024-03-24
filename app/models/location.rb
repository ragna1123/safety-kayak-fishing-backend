# frozen_string_literal: true

class Location < ApplicationRecord
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  has_many :favorite_locations, dependent: :destroy
  has_many :trips, dependent: :destroy
end
