require 'rails_helper'

RSpec.describe TripTide, type: :model do
  let(:trip) { create(:trip) }
  let(:tide_data) { create(:tide_data) }

  # trip_idの存在性をテスト
  it 'trip_idがない場合は無効であること' do
    trip_tide = TripTide.new(trip_id: nil, tide_data_id: tide_data.id)
    expect(trip_tide).not_to be_valid
  end

  # tide_data_idの存在性をテスト
  it 'tide_data_idがない場合は無効であること' do
    trip_tide = TripTide.new(trip_id: trip.id, tide_data_id: nil)
    expect(trip_tide).not_to be_valid
  end

  # trip_idとtide_data_idが存在する場合は有効であること
  it 'trip_idとtide_data_idが存在する場合は有効であること' do
    trip_tide = TripTide.new(trip_id: trip.id, tide_data_id: tide_data.id)
    expect(trip_tide).to be_valid
  end
end
