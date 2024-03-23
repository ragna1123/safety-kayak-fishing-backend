# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherData, type: :model do
  it '必須属性がない場合は無効であること' do
    weather_data = WeatherData.new
    weather_data.valid?
    expect(weather_data.errors[:time]).to include("can't be blank")
    expect(weather_data.errors[:cloud_cover]).to include("is not a number")
    expect(weather_data.errors[:humidity]).to include("is not a number")
    expect(weather_data.errors[:swell_direction]).to include("is not a number")
    expect(weather_data.errors[:wave_direction]).to include("is not a number")
    expect(weather_data.errors[:wind_wave_direction]).to include("is not a number")
    expect(weather_data.errors[:wind_direction]).to include("is not a number")
  end

  # cloud_coverの範囲をテスト
  it 'cloud_coverが0未満の場合は無効であること' do
    weather_data = WeatherData.new(cloud_cover: -1)
    expect(weather_data).not_to be_valid
    expect(weather_data.errors[:cloud_cover]).to include('must be greater than or equal to 0')
  end

  it 'cloud_coverが100より大きい場合は無効であること' do
    weather_data = WeatherData.new(cloud_cover: 101)
    expect(weather_data).not_to be_valid
    expect(weather_data.errors[:cloud_cover]).to include('must be less than or equal to 100')
  end

  # humidityの範囲をテスト
  it 'humidityが0未満の場合は無効であること' do
    weather_data = WeatherData.new(humidity: -1)
    expect(weather_data).not_to be_valid
    expect(weather_data.errors[:humidity]).to include('must be greater than or equal to 0')
  end

  it 'humidityが100より大きい場合は無効であること' do
    weather_data = WeatherData.new(humidity: 101)
    expect(weather_data).not_to be_valid
    expect(weather_data.errors[:humidity]).to include('must be less than or equal to 100')
  end

  # swell_directionの範囲をテスト
  it 'swell_directionが0未満の場合は無効であること' do
    weather_data = WeatherData.new(swell_direction: -1)
    expect(weather_data).not_to be_valid
    expect(weather_data.errors[:swell_direction]).to include('must be greater than or equal to 0')
  end

  it 'swell_directionが360より大きい場合は無効であること' do
    weather_data = WeatherData.new(swell_direction: 361)
    expect(weather_data).not_to be_valid
    expect(weather_data.errors[:swell_direction]).to include('must be less than or equal to 360')
  end

  # wave_directionの範囲をテスト
  it 'wave_directionが0未満の場合は無効であること' do
    weather_data = WeatherData.new(wave_direction: -1)
    expect(weather_data).not_to be_valid
    expect(weather_data.errors[:wave_direction]).to include('must be greater than or equal to 0')
  end

  it 'wave_directionが360より大きい場合は無効であること' do
    weather_data = WeatherData.new(wave_direction: 361)
    expect(weather_data).not_to be_valid
    expect(weather_data.errors[:wave_direction]).to include('must be less than or equal to 360')
  end

  # wind_wave_directionの範囲をテスト
  it 'wind_wave_directionが0未満の場合は無効であること' do
    weather_data = WeatherData.new(wind_wave_direction: -1)
    expect(weather_data).not_to be_valid
    expect(weather_data.errors[:wind_wave_direction]).to include('must be greater than or equal to 0')
  end

  it 'wind_wave_directionが360より大きい場合は無効であること' do
    weather_data = WeatherData.new(wind_wave_direction: 361)
    expect(weather_data).not_to be_valid
    expect(weather_data.errors[:wind_wave_direction]).to include('must be less than or equal to 360')
  end

  # wind_directionの範囲をテスト
  it 'wind_directionが0未満の場合は無効であること' do
    weather_data = WeatherData.new(wind_direction: -1)
    expect(weather_data).not_to be_valid
    expect(weather_data.errors[:wind_direction]).to include('must be greater than or equal to 0')
  end

  it 'wind_directionが360より大きい場合は無効であること' do
    weather_data = WeatherData.new(wind_direction: 361)
    expect(weather_data).not_to be_valid
    expect(weather_data.errors[:wind_direction]).to include('must be less than or equal to 360')
  end
end
