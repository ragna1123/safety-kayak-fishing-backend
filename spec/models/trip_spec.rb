# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trip, type: :model do
  # user_idの存在性をテスト
  it 'user_idがない場合は無効であること' do
    trip = Trip.new(user_id: nil, location_id: 1, departure_time: Time.now, estimated_return_time: Time.now + 1.hour,
                    details: '楽しい旅行')
    expect(trip).not_to be_valid
  end

  # location_idの存在性をテスト
  it 'location_idがない場合は無効であること' do
    trip = Trip.new(user_id: 1, location_id: nil, departure_time: Time.now, estimated_return_time: Time.now + 1.hour,
                    details: '楽しい旅行')
    expect(trip).not_to be_valid
  end

  # departure_timeの存在性をテスト
  it 'departure_timeがない場合は無効であること' do
    trip = Trip.new(user_id: 1, location_id: 1, departure_time: nil, estimated_return_time: Time.now + 1.hour,
                    details: '楽しい旅行')
    expect(trip).not_to be_valid
  end

  # estimated_return_timeの存在性をテスト
  it 'estimated_return_timeがない場合は無効であること' do
    trip = Trip.new(user_id: 1, location_id: 1, departure_time: Time.now, estimated_return_time: nil, details: '楽しい旅行')
    expect(trip).not_to be_valid
  end

  # detailsがnilでも有効であることをテスト
  it 'detailsがnilの場合でも有効であること' do
    trip = Trip.new(user_id: 1, location_id: 1, departure_time: Time.now, estimated_return_time: Time.now + 1.hour,
                    details: nil)
    expect(trip).to be_valid
  end

  # detailsの長さが256文字以上の場合は無効であることをテスト
  it 'detailsが256文字以上の場合は無効であること' do
    long_details = 'a' * 256
    trip = Trip.new(user_id: 1, location_id: 1, departure_time: Time.now, estimated_return_time: Time.now + 1.hour,
                    details: long_details)
    expect(trip).not_to be_valid
  end

  # detailsの長さが255文字以下の場合は有効であることをテスト
  it 'detailsが255文字以下の場合は有効であること' do
    short_details = 'a' * 255
    trip = Trip.new(user_id: 1, location_id: 1, departure_time: Time.now, estimated_return_time: Time.now + 1.hour,
                    details: short_details)
    expect(trip).to be_valid
  end
end
