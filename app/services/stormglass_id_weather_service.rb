class StormglassIdWeatherService
  include HTTParty
  base_uri 'https://api.stormglass.io'

  def initialize(api_key)
    @options = {
      headers: {
        'Authorization' => ENV['STORMGLASS_API_KEY']
    }}
  end

  def fetch_weather_data(latitude, longitude)
    self.class.get("/v2/weather/point?lat=#{latitude}&lng=#{longitude}", @options)
  end
end
