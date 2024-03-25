# frozen_string_literal: true

RSpec.describe Trip, type: :model do
  let(:user) { create(:user) }
  let(:location) { create(:location) }
  let(:valid_departure_time) { Time.zone.now + 5.days } # 有効な出発時間
  let(:valid_estimated_return_time) { valid_departure_time + 10.hours } # 有効な帰還予定時間
  let(:trip) do
    create(:trip, user:, location:, departure_time: valid_departure_time,
                  estimated_return_time: valid_estimated_return_time)
  end

  it 'ユーザーIDがない場合は無効であること' do
    trip.user_id = nil
    expect(trip).not_to be_valid
  end

  it 'ロケーションIDがない場合は無効であること' do
    trip.location_id = nil
    expect(trip).not_to be_valid
  end

  it '出発時間がない場合は無効であること' do
    trip.departure_time = nil
    expect(trip).not_to be_valid
  end

  it '推定帰還時間がない場合は無効であること' do
    trip.estimated_return_time = nil
    expect(trip).not_to be_valid
  end

  it '詳細が256文字以上の場合は無効であること' do
    trip.details = 'a' * 256
    expect(trip).not_to be_valid
  end

  it '詳細が255文字以下の場合は有効であること' do
    trip.details = 'a' * 255
    expect(trip).to be_valid
  end

  it '帰還詳細が256文字以上の場合は無効であること' do
    trip.return_details = 'a' * 256
    expect(trip).not_to be_valid
  end

  it '帰還詳細が255文字以下の場合は有効であること' do
    trip.return_details = 'a' * 255
    expect(trip).to be_valid
  end
end
