class WeatherRecordingWorker
  include Sidekiq::Worker

  def perform(location_id)
    location = Location.find(location_id)
    
    # 気象サービスからデータを取得
    weather_data = fetch_weather_data(location.latitude, location.longitude)

    # 取得した気象データをデータベースに保存
    WeatherData.create!(
      time: Time.current, # またはAPIから取得した時刻
      airTemperature: weather_data[:temperature],
      pressure: weather_data[:pressure],
      cloudCover: weather_data[:cloud_cover],
      gust: weather_data[:gust],
      humidity: weather_data[:humidity],
      precipitation: weather_data[:precipitation],
      swellDirection: weather_data[:swell_direction],
      swellHeight: weather_data[:swell_height],
      swellPeriod: weather_data[:swell_period],
      visibility: weather_data[:visibility],
      waterTemperature: weather_data[:water_temperature],
      waveDirection: weather_data[:wave_direction],
      waveHeight: weather_data[:wave_height],
      wavePeriod: weather_data[:wave_period],
      windWaveDirection: weather_data[:wind_wave_direction],
      windWaveHeight: weather_data[:wind_wave_height],
      windWavePeriod: weather_data[:wind_wave_period],
      windDirection: weather_data[:wind_direction],
      windSpeed: weather_data[:wind_speed],
    )
  end

  private

  def fetch_weather_data(latitude, longitude)
    # 外部気象情報サービスを呼び出してデータを取得
    # このメソッドは、取得した気象データをハッシュとして返す
    # { temperature: 20.5, wind_speed: 5.2, wind_direction: 270, wave_height: 1.2 } のような形式
    WeatherService.new.fetch_data(latitude, longitude)
  end
end
