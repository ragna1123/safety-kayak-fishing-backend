# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Location, type: :model do
  # latitudeの存在性をテスト
  it 'latitudeがない場合は無効であること' do
    location = Location.new(latitude: nil, longitude: 35.6895)
    expect(location).not_to be_valid
  end

  # longitudeの存在性をテスト
  it 'longitudeがない場合は無効であること' do
    location = Location.new(latitude: 139.6917, longitude: nil)
    expect(location).not_to be_valid
  end

  # latitudeとlongitudeが存在する場合は有効であること
  it 'latitudeとlongitudeが存在する場合は有効であること' do
    location = Location.new(latitude: 35.0, longitude: 135.0)
    expect(location).to be_valid
  end
end
