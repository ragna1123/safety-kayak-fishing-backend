# frozen_string_literal: true

class FavoriteLocation < ApplicationRecord
  validates :user_id, presence: true
  validates :location_id, presence: true
  validates :name, presence: true
  validates :description, length: { maximum: 255 }
end
