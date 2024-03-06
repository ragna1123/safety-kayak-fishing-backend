class FavoriteLocation < ApplicationRecord
  validates :user_id, presence: true
  validates :location_id, presence: true
  validates :name, presence: true
  validates :description, allow_nil: true,length: {maximum: 255}
end
