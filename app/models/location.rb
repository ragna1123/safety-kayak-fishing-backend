# frozen_string_literal: true

class Location < ApplicationRecord
  validates :latitude, presence: true
  validates :longtude, presence: true
  belongs_to :trip
end
