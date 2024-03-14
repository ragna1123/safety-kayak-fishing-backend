# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripWeather, type: :model do
  let(:trip) { create(:trip) }
  let(:weather_data) { create(:weather_data) }
  # trip_idの存在性をテスト
  it 'trip_idがない場合は無効であること' do
    trip_weather = TripWeather.new(trip_id: nil, weather_data_id: weather_data.id)
    expect(trip_weather).not_to be_valid
  end

  # weather_data_idの存在性をテスト
  it 'weather_data_idがない場合は無効であること' do
    trip_weather = TripWeather.new(trip_id: trip.id, weather_data_id: nil)
    expect(trip_weather).not_to be_valid
  end

  # trip_idとweather_data_idが存在する場合は有効であること
  it 'trip_idとweather_data_idが存在する場合は有効であること' do
    trip_weather = TripWeather.new(trip_id: trip.id, weather_data_id: weather_data.id)
    expect(trip_weather).to be_valid
  end
end
