# frozen_string_literal: true

class StormGlassIoWeatherService
  include HTTParty
  base_uri 'https://api.stormglass.io'

  def initialize
    @options = {
      headers: {
        'Authorization' => ENV['STORM_GLASS_IO_API_KEY']
      }
    }

    @params = %w[
      airTemperature
      pressure
      cloudCover
      gust
      humidity
      precipitation
      swellDirection
      swellHeight
      swellPeriod
      visibility
      waterTemperature
      waveDirection
      waveHeight
      wavePeriod
      windWaveDirection
      windWaveHeight
      windWavePeriod
      windDirection
      windSpeed
    ]

    @source = 'sg'
  end

  def fetch_weather_data(latitude, longitude)
    params = {
      params: @params.join(','),
      lat: latitude,
      lng: longitude,
      source: @source,
      start: Time.now.to_i,
      end: Time.now.to_i + 1.hour
    }

    response = self.class.get('/v2/weather/point', query: params, headers: @options[:headers])

    if response.success?
      extract_weather_data(response)
    else
      # Handle errors or return a default structure
      {}
    end
  end

  private

  def extract_weather_data(response)
    # APIのレスポンスから必要なデータを抽出するロジック
    response['hours']
  end
end
