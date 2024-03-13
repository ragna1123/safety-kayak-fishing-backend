# frozen_string_literal: true

class Trip < ApplicationRecord
  validates :user_id, presence: true
  validates :location_id, presence: true
  validates :departure_time, presence: true
  validates :estimated_return_time, presence: true
  validates :details, allow_nil: true, length: { maximum: 255 }
end
