class StormglassIdTideService
  include HTTParty
  base_uri 'https://api.stormglass.io'

  def initialize(api_key)
    @options = {
      headers: {
        'Authorization' => ENV['STORMGLASS_API_KEY']
    }}
  end

  def fetch_tide_data(latitude, longitude, start_time, end_time)
    query = {
      lat: latitude,
      lng: longitude,
      start: start_time.to_i,  # 時間はUnixタイムスタンプで指定
      end: end_time.to_i
    }

    self.class.get("/v2/tide/sea-level", @options.merge(query: query))
  end
end
