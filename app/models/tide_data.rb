# frozen_string_literal: true

class TideData < ApplicationRecord
  # バリデーション
  validates :time, presence: true
  validates :tide_type, presence: true
  validates :height, presence: true

  belongs_to :location

  # tide_data テーブルと trips テーブルの多対多の関連を設定
  has_many :trip_tides
  has_many :trips, through: :trip_tides

end
