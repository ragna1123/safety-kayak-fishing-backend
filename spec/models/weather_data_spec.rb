require 'rails_helper'

RSpec.describe WeatherData, type: :model do
  # weather_conditionの存在性をテスト
  it 'weather_conditionがない場合は無効であること' do
    weather_data = WeatherData.new(weather_condition: nil, timestamp: Time.now, temperature: 25, wind_speed: 5, wind_direction: 90, wave_height: 2)
    expect(weather_data).not_to be_valid
  end

  # timestampの存在性をテスト
  it 'timestampがない場合は無効であること' do
    weather_data = WeatherData.new(weather_condition: '晴れ', timestamp: nil, temperature: 25, wind_speed: 5, wind_direction: 90, wave_height: 2)
    expect(weather_data).not_to be_valid
  end

  # temperatureの存在性をテスト
  it 'temperatureがない場合は無効であること' do
    weather_data = WeatherData.new(weather_condition: '晴れ', timestamp: Time.now, temperature: nil, wind_speed: 5, wind_direction: 90, wave_height: 2)
    expect(weather_data).not_to be_valid
  end

  # wind_speedの存在性をテスト
  it 'wind_speedがない場合は無効であること' do
    weather_data = WeatherData.new(weather_condition: '晴れ', timestamp: Time.now, temperature: 25, wind_speed: nil, wind_direction: 90, wave_height: 2)
    expect(weather_data).not_to be_valid
  end

  # wind_directionの存在性をテスト
  it 'wind_directionがない場合は無効であること' do
    weather_data = WeatherData.new(weather_condition: '晴れ', timestamp: Time.now, temperature: 25, wind_speed: 5, wind_direction: nil, wave_height: 2)
    expect(weather_data).not_to be_valid
  end

  # wave_heightの存在性をテスト
  it 'wave_heightがない場合は無効であること' do
    weather_data = WeatherData.new(weather_condition: '晴れ', timestamp: Time.now, temperature: 25, wind_speed: 5, wind_direction: 90, wave_height: nil)
    expect(weather_data).not_to be_valid
  end
end
