# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FavoriteLocation, type: :model do
  let(:user) { create(:user) }
  let(:location) { create(:location) }
  # user_idの存在性をテスト
  it 'user_idがない場合は無効であること' do
    favorite_location = FavoriteLocation.new(user_id: nil, location_id: location.id, name: 'お気に入りの場所', description: '素晴らしい場所です')
    expect(favorite_location).not_to be_valid
  end

  # location_idの存在性をテスト
  it 'location_idがない場合は無効であること' do
    favorite_location = FavoriteLocation.new(user_id: user.id, location_id: nil, name: 'お気に入りの場所', description: '素晴らしい場所です')
    expect(favorite_location).not_to be_valid
  end

  # nameの存在性をテスト
  it 'nameがない場合は無効であること' do
    favorite_location = FavoriteLocation.new(user_id: user.id, location_id: location.id, name: nil, description: '素晴らしい場所です')
    expect(favorite_location).not_to be_valid
  end

  # descriptionの長さをテスト
  it 'descriptionが256文字以上の場合は無効であること' do
    long_description = 'a' * 256
    favorite_location = FavoriteLocation.new(user_id: user.id, location_id: location.id, name: 'お気に入りの場所',
                                             description: long_description)
    expect(favorite_location).not_to be_valid
  end

  it 'descriptionが255文字以下の場合は有効であること' do
    short_description = 'a' * 255
    favorite_location = FavoriteLocation.new(user_id: user.id, location_id: location.id, name: 'お気に入りの場所',
                                             description: short_description)
    expect(favorite_location).to be_valid
  end
end
