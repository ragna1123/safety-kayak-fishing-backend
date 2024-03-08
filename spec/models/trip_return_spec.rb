# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripReturn, type: :model do
  # trip_idの存在性をテスト
  it 'trip_idがない場合は無効であること' do
    trip_return = TripReturn.new(trip_id: nil, return_time: Time.now, return_details: '無事に戻りました')
    expect(trip_return).not_to be_valid
  end

  # return_timeの存在性をテスト
  it 'return_timeがない場合は無効であること' do
    trip_return = TripReturn.new(trip_id: 1, return_time: nil, return_details: '無事に戻りました')
    expect(trip_return).not_to be_valid
  end

  # return_detailsの長さをテスト
  it 'return_detailsが256文字以上の場合は無効であること' do
    long_details = 'a' * 256
    trip_return = TripReturn.new(trip_id: 1, return_time: Time.now, return_details: long_details)
    expect(trip_return).not_to be_valid
  end

  it 'return_detailsが255文字以下の場合は有効であること' do
    short_details = 'a' * 255
    trip_return = TripReturn.new(trip_id: 1, return_time: Time.now, return_details: short_details)
    expect(trip_return).to be_valid
  end
end
