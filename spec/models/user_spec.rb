# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  # ユーザー名の存在性をテスト
  it 'ユーザー名がない場合は無効であること' do
    user = User.new(username: nil, email: 'test@example.com', password: 'password123')
    expect(user).not_to be_valid
  end

  # メールの存在性と一意性をテスト
  it 'メールアドレスがない場合は無効であること' do
    user = User.new(username: 'testuser', email: nil, password: 'password123')
    expect(user).not_to be_valid
  end

  it '重複したメールアドレスの場合は無効であること' do
    User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
    user = User.new(username: 'testuser2', email: 'test@example.com', password: 'password123')
    expect(user).not_to be_valid
  end

  # メールアドレスのフォーマットをテスト
  it 'メールアドレスが正しいフォーマットの場合は有効であること' do
    user = User.new(username: 'testuser', email: 'test@example.com', password: 'password123')
    expect(user).to be_valid
  end

  it 'メールアドレスが正しくないフォーマットの場合は無効であること' do
    user = User.new(username: 'testuser', email: 'test@emial', password: 'password123')
    expect(user).not_to be_valid
  end

  # プロファイル画像のURLのnil許容をテスト
  it 'プロファイル画像のURLがnilでも有効であること' do
    user = User.new(username: 'testuser', email: 'test@example.com', profile_image_url: nil, password: 'password123')
    expect(user).to be_valid
  end

  # パスワードのバリデーションをテスト
  it 'パスワードが6文字未満の場合は無効であること' do
    user = User.new(username: 'testuser', email: 'test@example.com', password: 'pass')
    expect(user).not_to be_valid
  end

  it 'パスワードが指定されたフォーマットに一致しない場合は無効であること' do
    user = User.new(username: 'testuser', email: 'test@example.com', password: 'password@123')
    expect(user).not_to be_valid
  end

  it 'パスワードが正しいフォーマットの場合は有効であること' do
    user = User.new(username: 'testuser', email: 'test@example.com', password: 'password123')
    expect(user).to be_valid
  end
end
