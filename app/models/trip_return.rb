# frozen_string_literal: true

class TripReturn < ApplicationRecord
  validates :trip_id, presence: true
  validates :return_time, presence: true
  validates :return_details, length: { maximum: 255 }
end
