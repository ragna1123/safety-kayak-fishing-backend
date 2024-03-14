# frozen_string_literal: true

class Trip < ApplicationRecord
  validates :user_id, presence: true
  validates :location_id, presence: true
  validates :departure_time, presence: true
  validates :estimated_return_time, presence: true
  validates :details, length: { maximum: 255 }
  validates :return_details, length: { maximum: 255 }

  belongs_to :user
  belongs_to :location
end
