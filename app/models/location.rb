# frozen_string_literal: true

class Location < ApplicationRecord
  validates :latitude, presence: true
  validates :longitude, presence: true
end
