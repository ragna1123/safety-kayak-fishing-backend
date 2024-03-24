class TripTide < ApplicationRecord
  belongs_to :trip
  belongs_to :tide_data
end
