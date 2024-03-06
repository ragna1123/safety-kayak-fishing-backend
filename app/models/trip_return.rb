class TripReturn < ApplicationRecord
  validates :trip_id, presence: true
  validates :return_time, presence: true
  validates :return_details, allow_nil: true, length: {maximum: 255}
end
