class SunriseSunsetService
  include HTTParty
  base_uri 'https://api.sunrise-sunset.org'

  def initialize(departure_time, location)
    @date = departure_time.to_date
    @latitude = location.latitude
    @longitude = location.longitude
  end

  def call
    response = self.class.get("/json?lat=#{@latitude}&lng=#{@longitude}&date=#{@date}")
    if response.success?
      sunrise_time = parse_time(response['results']['sunrise'])
      sunset_time = parse_time(response['results']['sunset'])

      { sunrise: sunrise_time, sunset: sunset_time }
    else
      { error: "APIからエラーレスポンスが返されました: ステータスコード #{response.code}" }
    end
  rescue HTTParty::Error => e
    { error: "HTTPartyエラー: #{e.message}" }
  rescue StandardError => e
    { error: "標準エラー: #{e.message}" }
  end

  private

  def parse_time(time_str)
    # UTC時刻をパースし、Railsアプリケーションのタイムゾーンに変換します。
    Time.zone.parse(time_str + ' UTC').in_time_zone
  end
end

