# frozen_string_literal: true

class Trip < ApplicationRecord
  validates :user_id, presence: true
  validates :location_id, presence: true
  validates :departure_time, presence: true
  validates :estimated_return_time, presence: true
  validates :details, length: { maximum: 255 }
  validates :return_details, length: { maximum: 255 }

  # custom validation
  validate :validate_departure_time
  validate :validate_estimated_return_time

  belongs_to :user
  belongs_to :location

  has_many :trip_weathers, dependent: :destroy
  has_many :weather_data, through: :trip_weathers
  has_many :trip_tides, dependent: :destroy
  has_many :tide_data, through: :trip_tides

  # future_trips スコープは、出発時間が現在時刻より未来のトリップを返します。
  scope :future_trips, -> { where('departure_time > ?', Time.zone.now) }
  # active_trips スコープは、出船中の予定を返します。
  scope :active_trips, -> { where('departure_time <= ? AND estimated_return_time >= ?', Time.zone.now, Time.zone.now) }
  # past_trips スコープは、帰還予定時間が現在時刻より過去のトリップを返します。
  scope :past_trips, -> { where('estimated_return_time < ?', Time.zone.now) }
  # return_time が nil でないトリップを返します。
  scope :returned_trips, -> { where.not(return_time: nil) }
  # return_time が nil のトリップを返します。
  scope :unreturned_trips, -> { where(return_time: nil) }


  # トリップが終了していないか、許容期間内にあるかを判断
  def can_report_return?
    Time.zone.now <= estimated_return_time || within_allowable_return_period?
  end

  # 許容される帰投報告の期間を判断
  def within_allowable_return_period?
    Time.zone.now <= estimated_return_time + 15.minutes
  end

  private

  # 10日後までの予定を許可
  def validate_departure_time
    return if departure_time.blank?

    if departure_time < Time.zone.now || departure_time > Time.zone.now + 10.days
      errors.add(:departure_time, 'は現在から10日後までの範囲で設定してください')
    end
  end

  # departure_time の 18時間以内を許可
  def validate_estimated_return_time
    return if estimated_return_time.blank? || departure_time.blank?

    if estimated_return_time < Time.zone.now || estimated_return_time > departure_time + 18.hours
      errors.add(:estimated_return_time, 'は出発時間から24時間以内で設定してください')
    end
  end
  
end
