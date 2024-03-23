class TideData < ApplicationRecord
  belongs_to :location

  # バリデーション
  validates :time, presence: true
  validates :tide_type, presence: true
  validates :height, presence: true
end
