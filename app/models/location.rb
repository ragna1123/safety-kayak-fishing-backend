# frozen_string_literal: true

class Location < ApplicationRecord
  validates :latitude, presence: true
  validates :longtude, presence: true
  has_many :favorite_locations, dependent: :destroy
  has_many :trips, dependent: :destroy
end
