class WeatherAlertService

  TIME_ZONE = 'Tokyo'

  def initialize(trip, weather_data)
    @trip = trip
    @weather_data = weather_data
  end
  
  def call
    @weather_data.each do |data|
      check_and_send_alert(data) if alert_condition_met?(data)
    end
  end

  private

  def alert_condition_met?(data)
    wave_height = data.dig('waveHeight', 'sg')
    wind_speed = data.dig('windSpeed', 'sg')
    swell_height = data.dig('swellHeight', 'sg')

    wave_height >= 1.00 || wind_speed >= 3.1 || swell_height >= 0.4
  end

  def check_and_send_alert(data)
    send_alert("警告: #{format_alert_message(data)}") if alert_condition_met?(data)
  end

  def send_alert(message)
    # 出船中かどうかを確認
    if @trip.departure_time <= Time.zone.now && @trip.estimated_return_time >= Time.zone.now
      # トリップが出航している場合は、ユーザーにアラートを送信
      LineSendMessageService.new(@trip.user.line_id, message).call
      Rails.logger.info "アラートを送信しました: #{message}"
    end
  end

  def format_alert_message(data)
    time = data['time'].in_time_zone(TIME_ZONE).strftime('%H:%M')
    "【天候注意報】\n時刻: #{time}, 波の高さ: #{data.dig('waveHeight', 'sg')}m (方向: #{direction(data.dig('waveDirection', 'sg'))}), 風速: #{data.dig('windSpeed', 'sg')}m/s (方向: #{direction(data.dig('windDirection', 'sg'))}), うねりの高さ: #{data.dig('swellHeight', 'sg')}m (方向: #{direction(data.dig('swellDirection', 'sg'))})\n注意: 帰投が難しくなる予報が出ています。安全第一で行動してください。必要に応じて早めの帰投も検討してください。"
  end

  def direction(degree)
    case degree
    when 0...22.5, 337.5...360
      "北"
    when 22.5...67.5
      "北東"
    when 67.5...112.5
      "東"
    when 112.5...157.5
      "南東"
    when 157.5...202.5
      "南"
    when 202.5...247.5
      "南西"
    when 247.5...292.5
      "西"
    when 292.5...337.5
      "北西"
    else
      "不明"
    end
  end
end


