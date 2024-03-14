# frozen_string_literal: true

FactoryBot.define do
  factory :weather_data do
    weather_condition { '晴れ' }
    timestamp { '2024-03-15 08:00:00' }
    temperature { 20.0 }
    wind_speed { 5.0 }
    wind_direction { 90.0 }
    wave_height { 1.0 }
    tide { '中潮' }
    tide_level { 1.0 }
  end
end
