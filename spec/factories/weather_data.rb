# frozen_string_literal: true

FactoryBot.define do
  factory :weather_data do
    time { DateTime.now } # デフォルトで現在の日時を使用する例
    air_temperature { 20.0 } # 例として20.0を使用
    pressure { 1013.25 } # 例として1013.25を使用
    cloud_cover { 50 } # 例として50を使用
    gust { 25.0 } # 例として25.0を使用
    humidity { 60 } # 例として60を使用
    precipitation { 0.0 } # 例として0.0を使用
    swell_direction { 180.0 } # 例として180.0を使用
    swell_height { 1.5 } # 例として1.5を使用
    swell_period { 10.0 } # 例として10.0を使用
    visibility { 10.0 } # 例として10.0を使用
    water_temperature { 18.0 } # 例として18.0を使用
    wave_direction { 220.0 } # 例として220.0を使用
    wave_height { 2.0 }  # 例として2.0を使用
    wave_period { 8.0 }  # 例として8.0を使用
    wind_wave_direction { 270.0 } # 例として270.0を使用
    wind_wave_height { 0.5 }  # 例として0.5を使用
    wind_wave_period { 6.0 }  # 例として6.0を使用
    wind_direction { 90.0 } # 例として90.0を使用
    wind_speed { 15.0 } # 例として15.0を使用
  end
end
