# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feedback, type: :model do
  # user_idの存在性をテスト
  it 'user_idがない場合は無効であること' do
    feedback = Feedback.new(user_id: nil, title: 'フィードバックのタイトル', comment: '素晴らしいアプリです！')
    expect(feedback).not_to be_valid
  end

  # titleの存在性をテスト
  it 'titleがない場合は無効であること' do
    feedback = Feedback.new(user_id: 1, title: nil, comment: '素晴らしいアプリです！')
    expect(feedback).not_to be_valid
  end

  # commentの存在性と長さをテスト
  it 'commentがない場合は無効であること' do
    feedback = Feedback.new(user_id: 1, title: 'フィードバックのタイトル', comment: nil)
    expect(feedback).not_to be_valid
  end

  it 'commentが256文字以上の場合は無効であること' do
    long_comment = 'a' * 256
    feedback = Feedback.new(user_id: 1, title: 'フィードバックのタイトル', comment: long_comment)
    expect(feedback).not_to be_valid
  end

  it 'commentが255文字以下の場合は有効であること' do
    short_comment = 'a' * 255
    feedback = Feedback.new(user_id: 1, title: 'フィードバックのタイトル', comment: short_comment)
    expect(feedback).to be_valid
  end
end
