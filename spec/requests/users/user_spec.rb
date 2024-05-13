# frozen_string_literal: true

require 'rails_helper'
require 'support/cookies'


RSpec.describe 'ユーザー情報周り', type: :request do
  let(:user) { create(:user) }
  let(:token) { create_token_for(user) }
  let(:auth_headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:no_auth_headers) { { 'Authorization' => '' } }

    before do
      cookies.signed[:jwt] = { value: token, httponly: true, expires: 1.month.from_now }
    end

  describe 'GET /api/users ユーザー情報の取得' do
    context '有効なトークンでのリクエストの場合' do
      it 'ユーザー情報を返すこと' do
        get('/api/users' )
        expect(response).to have_http_status(:ok)
        expect(json_response['user']).to include('id', 'username', 'email', 'profile_image_url')
      end
    end

    context 'トークンなしでのリクエストの場合' do
      it '未認証を返すこと' do
        get('/api/users', headers: no_auth_headers)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /api/users ユーザー情報の更新' do
    let(:new_attributes) { { username: 'updateduser', email: 'updated@example.com' } }

    context '有効なトークンでのリクエストの場合' do
      it 'ユーザー情報を更新する' do
        put('/api/users', params: { user: new_attributes }, headers: auth_headers)
        expect(response).to have_http_status(:ok)
        user.reload
        expect(user.username).to eq(new_attributes[:username])
        expect(user.email).to eq(new_attributes[:email])
      end
    end

    context 'トークンなしでのリクエストの場合' do
      it '未認証を返す' do
        put('/api/users', params: { user: new_attributes }, headers: no_auth_headers)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/users ユーザー情報の削除' do
    context '有効なトークンでのリクエストの場合' do
      it 'ユーザーを削除する' do
        delete('/api/users', headers: auth_headers)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'トークンなしでのリクエストの場合' do
      it '未認証を返す' do
        delete('/api/users', headers: no_auth_headers)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end
