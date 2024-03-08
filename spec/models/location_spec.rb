require 'rails_helper'

RSpec.describe Location, type: :model do
  # latitudeの存在性をテスト
  it 'latitudeがない場合は無効であること' do
    location = Location.new(latitude: nil, longtude: 35.6895)
    expect(location).not_to be_valid
  end

  # longtudeの存在性をテスト
  it 'longtudeがない場合は無効であること' do
    location = Location.new(latitude: 139.6917, longtude: nil)
    expect(location).not_to be_valid
  end

  # latitudeとlongitudeが存在する場合は有効であること
  it 'latitudeとlongtudeが存在する場合は有効であること' do
    location = Location.new(latitude: 35.0, longtude: 135.0)
    expect(location).to be_valid
  end
end