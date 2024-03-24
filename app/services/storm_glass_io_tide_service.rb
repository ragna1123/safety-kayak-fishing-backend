# frozen_string_literal: true

class StormGlassIoTideService
  include HTTParty
  base_uri 'https://api.stormglass.io'

  def initialize
    @options = {
      headers: {
        'Authorization' => ENV['STORM_GLASS_IO_API_KEY']
      }
    }
  end

  def fetch_tide_data(latitude, longitude, start_time, end_time)
    query = {
      lat: latitude,
      lng: longitude,
      start: start_time.to_i, # 時間はUnixタイムスタンプで指定
      end: end_time.to_i
    }

    self.class.get('/v2/tide/extremes/point', @options.merge(query:))
  end
end
