class WeatherAdvisoryWorker
  include Sidekiq::Worker

  WIND_THRESHOLD = 20 # 風速の閾値（例: 20m/s）
  WAVE_THRESHOLD = 3 # 波高の閾値（例: 3m）

  def perform
    Trip.where('departure_time <= ? AND (estimated_return_time IS NULL OR estimated_return_time >= ?)', 2.hours.ago, Time.now).each do |trip|
      weather_data = fetch_weather_data(trip.location.latitude, trip.location.longitude)

      if weather_data[:wind_speed] > WIND_THRESHOLD || weather_data[:wave_height] > WAVE_THRESHOLD
        send_line_message(trip.user, "警告: 現在の気象条件は安全基準を超えています。")
      end
    end
  end

  private

  def fetch_weather_data(latitude, longitude)
    # WeatherService を使用して気象データを取得
    # このメソッドは、取得した気象データ（風速と波高）をハッシュとして返す
    # { wind_speed: 25.5, wave_height: 3.5 } のような形式
    WeatherService.new.fetch_data(latitude, longitude)
  end

  def send_line_message(user, message)
    # LineSendMessageService を使用してLINEメッセージを送信
    LineSendMessageService.new(user, message).call
  end
end
