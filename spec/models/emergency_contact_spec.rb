# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmergencyContact, type: :model do
  # 名前の存在性をテスト
  it '名前がない場合は無効であること' do
    contact = EmergencyContact.new(name: nil, relationship: '友人', email: 'friend@example.com')
    expect(contact).not_to be_valid
  end

  # 関係性の存在性をテスト
  it '関係性がない場合は無効であること' do
    contact = EmergencyContact.new(name: '鈴木雄太', relationship: nil, email: 'friend@example.com')
    expect(contact).not_to be_valid
  end

  # メールアドレスの存在性と一意性をテスト
  it 'メールアドレスがない場合は無効であること' do
    contact = EmergencyContact.new(name: '鈴木雄太', relationship: '友人', email: nil)
    expect(contact).not_to be_valid
  end

  it 'メールアドレスが重複している場合は無効であること' do
    user = User.create!(username: 'テストユーザー', email: 'user@example.com', password: 'password')
    EmergencyContact.create!(name: '柴田ゆいと', relationship: '同僚', email: 'unique@example.com', user_id: user.id)
    contact = EmergencyContact.new(name: '鈴木雄太', relationship: '友人', email: 'unique@example.com', user_id: user.id)
    expect(contact).not_to be_valid
  end
end
