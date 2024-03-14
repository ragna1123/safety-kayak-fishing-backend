class SunriseSunsetService
  include HTTParty
  base_uri 'https://api.sunrise-sunset.org'

  def initialize(departure_time, location)
    @date = departure_time
    @latitude = location.latitude
    @longitude = location.longitude
  end

  def call
    response = self.class.get("/json?lat=#{@latitude}&lng=#{@longitude}&date=#{@date}")
    if response.success?
      {
        sunrise: Time.zone.parse(response['results']['sunrise']),
        sunset: Time.zone.parse(response['results']['sunset'])
      }
    else
      { error: "APIからのエラーレスポンス: #{response.status}" }
    end
  rescue HTTParty::Error => e
    { error: "HTTPartyエラー: #{e.message}" }
  rescue StandardError => e
    { error: "標準エラー: #{e.message}" }
  end
end
