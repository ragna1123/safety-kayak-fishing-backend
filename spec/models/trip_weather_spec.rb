require 'rails_helper'

RSpec.describe TripWeather, type: :model do
  # trip_idの存在性をテスト
  it 'trip_idがない場合は無効であること' do
    trip_weather = TripWeather.new(trip_id: nil, weather_data_id: 1)
    expect(trip_weather).not_to be_valid
  end

  # weather_data_idの存在性をテスト
  it 'weather_data_idがない場合は無効であること' do
    trip_weather = TripWeather.new(trip_id: 1, weather_data_id: nil)
    expect(trip_weather).not_to be_valid
  end

  # trip_idとweather_data_idが存在する場合は有効であること
  it 'trip_idとweather_data_idが存在する場合は有効であること' do
    trip_weather = TripWeather.new(trip_id: 1, weather_data_id: 1)
    expect(trip_weather).to be_valid
  end
end


