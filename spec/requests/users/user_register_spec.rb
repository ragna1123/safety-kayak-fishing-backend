# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :request do
  let(:user_attributes) { attributes_for(:user) } # FactoryBotを使用してユーザー属性を生成

  describe 'POST /api/users' do
    context '有効なパラメータ' do
      it '新しいユーザーの作成' do
        post '/api/users', params: { user: user_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context '無効なメールアドレス' do
      it '新しいユーザーを作成しない' do
        post '/api/users', params: { user: user_attributes.merge(email: 'invalid') }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'パスワードの不一致' do
      it '新しいユーザーを作成しない' do
        post '/api/users', params: { user: user_attributes.merge(password_confirmation: 'wrong') }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
