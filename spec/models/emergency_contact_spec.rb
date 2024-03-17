# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmergencyContact, type: :model do
  let(:user) { create(:user) }

  # 名前の存在性をテスト
  it '名前がない場合は無効であること' do
    contact = EmergencyContact.new(name: nil, relationship: '友人', email: 'friend@example.com', user:)
    expect(contact).not_to be_valid
  end

  # 関係性の存在性をテスト
  it '関係性がない場合は無効であること' do
    contact = EmergencyContact.new(name: '鈴木雄太', relationship: nil, email: 'friend@example.com', user:)
    expect(contact).not_to be_valid
  end

  # メールアドレスの存在性と一意性をテスト
  it 'メールアドレスがない場合は無効であること' do
    contact = EmergencyContact.new(name: '鈴木雄太', relationship: '友人', email: nil, user:)
    expect(contact).not_to be_valid
  end

  it 'メールアドレスが重複している場合は無効であること' do
    EmergencyContact.create!(name: '柴田ゆいと', relationship: '同僚', email: 'unique@example.com', user:)
    contact = EmergencyContact.new(name: '鈴木雄太', relationship: '友人', email: 'unique@example.com', user:)
    expect(contact).not_to be_valid
  end

  # メールアドレスのフォーマットをテスト
  it 'メールアドレスが正しいフォーマットの場合は有効であること' do
    contact = EmergencyContact.new(name: '鈴木雄太', relationship: '友人', email: 'user1111@example.com', user:)
    expect(contact).to be_valid
  end

  it 'メールアドレスが正しくないフォーマットの場合は無効であること' do
    contact = EmergencyContact.new(name: '鈴木雄太', relationship: '友人', email: 'user@example', user:)
    expect(contact).not_to be_valid
  end
end
