# frozen_string_literal: true

class WeatherRecordingWorker
  include Sidekiq::Worker

  def perform(trip_id)
    trip = Trip.find_by(id: trip_id)
    location = trip.location

    # 気象サービスからデータを取得
    weather_data = fetch_weather_data(location.latitude, location.longitude)

    # 取得した気象データをデータベースに保存
    weather_data.each do |data|
      trip.weather_data.create!(
        time: data['time'],
        air_temperature: data['airTemperature']['sg'],
        pressure: data['pressure']['sg'],
        cloud_cover: data['cloudCover']['sg'],
        gust: data['gust']['sg'],
        humidity: data['humidity']['sg'],
        precipitation: data['precipitation']['sg'],
        swell_direction: data['swellDirection']['sg'],
        swell_height: data['swellHeight']['sg'],
        swell_period: data['swellPeriod']['sg'],
        visibility: data['visibility']['sg'],
        water_temperature: data['waterTemperature']['sg'],
        wave_direction: data['waveDirection']['sg'],
        wave_height: data['waveHeight']['sg'],
        wave_period: data['wavePeriod']['sg'],
        wind_wave_direction: data['windWaveDirection']['sg'],
        wind_wave_height: data['windWaveHeight']['sg'],
        wind_wave_period: data['windWavePeriod']['sg'],
        wind_direction: data['windDirection']['sg'],
        wind_speed: data['windSpeed']['sg']
      )
      # 閾値の設定
      
      
      # 風速が3.1m/s以上のデータを取得 || 波が1m以上のデータを取得0.4m以上のデータを取得
      if data['windSpeed']['sg'] >= 3.1 || data['waveHeight']['sg'] >= 1 || data['swellHeight']['sg'] >= 0.4
        # 気象警報を作成
        trip.weather_alerts.create!(
          time: data['time'],
          wind_speed: data['windSpeed']['sg'],
          wave_height: data['waveHeight']['sg'],
          swell_height: data['swellHeight']['sg']
        )
      end
    end


  end

  private

  # 気象データを取得するメソッド
  def fetch_weather_data(latitude, longitude)
    # StormglassIoWeatherService インスタンスを作成してデータを取得
    StormGlassIoWeatherService.new.fetch_weather_data(latitude, longitude)
  end
end
