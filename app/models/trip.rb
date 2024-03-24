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

  # trip が作成された後、天気情報の記録をスケジュールを登録
  after_create :fetch_past_and_immediate_weather_data, :schedule_future_weather_recording

  # トリップが終了していないか、許容期間内にあるかを判断
  def can_report_return?
    Time.zone.now <= estimated_return_time || within_allowable_return_period?
  end

  # 許容される帰投報告の期間を判断（例: 帰還予定時間から24時間以内など）
  def within_allowable_return_period?
    Time.zone.now <= estimated_return_time + 15.minutes
  end

  private

  def fetch_past_and_immediate_weather_data
    return unless departure_time < Time.current

    Rails.logger.info "トリップ #{id} の過去および即時の天気データを取得中"
    begin
      (departure_time.to_i..Time.current.to_i).step(2.hours) do |time|
        WeatherRecordingWorker.perform_async(id, Time.at(time))
      end
    rescue StandardError => e
      Rails.logger.error "トリップ #{id} の過去および即時の天気データ取得に失敗しました: #{e.message}"
    end
  end

  # 未来の天気データのスケジュール
  def schedule_future_weather_recording
    future_intervals.each do |time|
      Rails.logger.info "トリップ #{id} に対して #{time} で WeatherRecordingWorker をスケジュール中"
      WeatherRecordingWorker.perform_at(time, id)
    end
  rescue StandardError => e
    Rails.logger.error "トリップ #{id} の未来の天気データスケジューリングに失敗しました: #{e.message}"
  end

  # 現在時刻から estimated_return_time の間を2時間ごとに分割
  def future_intervals
    intervals = []
    time = [Time.current, departure_time].max
    while time <= estimated_return_time
      intervals << time
      time += 2.hours
    end
    intervals
  end
end
