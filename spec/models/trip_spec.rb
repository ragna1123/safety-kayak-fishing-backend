# frozen_string_literal: true

RSpec.describe Trip, type: :model do
  let(:user) { create(:user) }
  let(:location) { create(:location) }
  let(:departure_time) { Time.now }
  let(:return_time) { departure_time + 1.hour }

  # user_idの存在性をテスト
  it 'user_idがない場合は無効であること' do
    trip = Trip.new(user_id: nil, location_id: location.id, departure_time:,
                    estimated_return_time: return_time)
    expect(trip).not_to be_valid
  end

  # location_idの存在性をテスト
  it 'location_idがない場合は無効であること' do
    trip = Trip.new(user_id: user.id, location_id: nil, departure_time:,
                    estimated_return_time: return_time)
    expect(trip).not_to be_valid
  end

  # departure_timeの存在性をテスト
  it 'departure_timeがない場合は無効であること' do
    trip = Trip.new(user_id: user.id, location_id: location.id, departure_time: nil, estimated_return_time: return_time)
    expect(trip).not_to be_valid
  end

  # estimated_return_timeの存在性をテスト
  it 'estimated_return_timeがない場合は無効であること' do
    trip = Trip.new(user_id: user.id, location_id: location.id, departure_time:,
                    estimated_return_time: nil)
    expect(trip).not_to be_valid
  end

  # detailsがnilでも有効であることをテスト
  it 'detailsがnilの場合でも有効であること' do
    trip = Trip.new(user_id: user.id, location_id: location.id, departure_time:,
                    estimated_return_time: return_time, details: nil)
    expect(trip).to be_valid
  end

  # detailsの長さが256文字以上の場合は無効であることをテスト
  it 'detailsが256文字以上の場合は無効であること' do
    long_details = 'a' * 256
    trip = Trip.new(user_id: user.id, location_id: location.id, departure_time:,
                    estimated_return_time: return_time, details: long_details)
    expect(trip).not_to be_valid
  end

  # detailsの長さが255文字以下の場合は有効であることをテスト
  it 'detailsが255文字以下の場合は有効であること' do
    short_details = 'a' * 255
    trip = Trip.new(user_id: user.id, location_id: location.id, departure_time:,
                    estimated_return_time: return_time, details: short_details)
    expect(trip).to be_valid
  end

  # return_timeがnilでも有効であることをテスト
  it 'return_timeがnilの場合でも有効であること' do
    trip = Trip.new(user_id: user.id, location_id: location.id, departure_time:,
                    estimated_return_time: return_time, return_time: nil)
    expect(trip).to be_valid
  end

  # return_detailsがnilでも有効であることをテスト
  it 'return_detailsがnilの場合でも有効であること' do
    trip = Trip.new(user_id: user.id, location_id: location.id, departure_time:,
                    estimated_return_time: return_time, return_details: nil)
    expect(trip).to be_valid
  end

  # return_detailsの長さが256文字以上の場合は無効であることをテスト
  it 'return_detailsが256文字以上の場合は無効であること' do
    long_details = 'a' * 256
    trip = Trip.new(user_id: user.id, location_id: location.id, departure_time:,
                    estimated_return_time: return_time, return_details: long_details)
    expect(trip).not_to be_valid
  end

  # return_detailsの長さが255文字以下の場合は有効であることをテスト
  it 'return_detailsが255文字以下の場合は有効であること' do
    short_details = 'a' * 255
    trip = Trip.new(user_id: user.id, location_id: location.id, departure_time:,
                    estimated_return_time: return_time, return_details: short_details)
    expect(trip).to be_valid
  end

end
