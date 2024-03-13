# frozen_string_literal: true

# spec/requests/user_registration_spec.rb
require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :request do
  let(:user_params) do
    {
      user: {
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      }
    }
  end

  describe 'POST /api/users' do
    context '有効なパラメータ' do
      before do
        post '/api/users', params: user_params
      end

      it '新しいユーザーの作成' do
        expect(response).to have_http_status(:created)
      end
    end

    context '無効なパラメータ' do
      before do
        post '/api/users',
             params: { user: { username: 'testuser', email: 'user', password: 'password',
                               password_confirmation: 'password' } }
      end

      it '新しいユーザーを作成しない' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
