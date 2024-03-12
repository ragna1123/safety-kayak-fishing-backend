require 'rails_helper'

RSpec.describe 'ユーザーの認証と情報取得', type: :request do
  let(:user) do
    User.create!(username: 'testuser', email: 'test@example.com', password: 'password123',
                 password_confirmation: 'password123')
  end
  let(:token) { create_token(user) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  before do
    allow_any_instance_of(ApplicationController).to receive(:jwt_authenticate).and_call_original
  end

  describe 'GET /api/users' do
    it '有効なトークンでユーザー情報を返すこと' do
      get('/api/users', headers:)
      expect(response).to have_http_status(:ok)
      expect(json_response['user']).to include('id', 'username', 'email', 'profile_image_url')
    end

    it 'トークンなしで未認証を返すこと' do
      get '/api/users'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PUT /api/users' do
    let(:new_attributes) do
      {
        username: 'updateduser',
        email: 'updated@example.com'
      }
    end

    context '有効なトークンで更新を行う場合' do
      it 'ユーザー情報を更新する' do
        put('/api/users', params: { user: new_attributes }, headers:)
        expect(response).to have_http_status(:ok)
        user.reload
        expect(user.username).to eq(new_attributes[:username])
        expect(user.email).to eq(new_attributes[:email])
      end
    end

    context 'トークンなしで更新を行う場合' do
      it '未認証を返す' do
        put '/api/users', params: { user: new_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/users' do
    context '有効なトークンで削除を行う場合' do
      it 'ユーザーを削除する' do
        delete('/api/users', headers:)
        expect(response).to have_http_status(:ok)
      end
    end

    context '無効なトークンで削除を行う場合' do
      it '未認証を返す' do
        delete '/api/users'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end

  def create_token(user)
    payload = { user_id: user.id }
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end
