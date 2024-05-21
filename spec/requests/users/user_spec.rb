# frozen_string_literal: true

require 'rails_helper'
require 'support/cookies'

RSpec.describe 'ユーザー情報周り', type: :request do
  let(:user) { create(:user) }
  let(:token) { create_token_for(user) }
  let(:unauthorized_header){{ 'Cookie' => "jwt=#{""}" }}


  before do
    # ここでクッキーをセットしている
    set_jwt_cookies(token)
  end
    
  describe 'GET /api/users ユーザー情報の取得' do
    context '有効なトークンでのリクエストの場合' do
      it 'ユーザー情報を返すこと' do
        get('/api/users')
        expect(response).to have_http_status(:ok)
        expect(json_response['user']).to include('id', 'username', 'email', 'profile_image_url')
      end
    end

    context 'トークンなしでのリクエストの場合' do
      it '未認証を返すこと' do
        cookies.delete(:jwt)
        get('/api/users', headers: unauthorized_header)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /api/users ユーザー情報の更新' do
    let(:new_attributes) { { username: 'updateduser', email: 'updated@example.com' } }

    context '有効なトークンでのリクエストの場合' do
      it 'ユーザー情報を更新する' do
        put('/api/users', params: { user: new_attributes } )
        expect(response).to have_http_status(:ok)
        user.reload
        expect(user.username).to eq(new_attributes[:username])
        expect(user.email).to eq(new_attributes[:email])
      end
    end

    context 'トークンなしでのリクエストの場合' do
      it '未認証を返す' do
        put('/api/users', params: { user: new_attributes }, headers: unauthorized_header)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/users ユーザー情報の削除' do
    context '有効なトークンでのリクエストの場合' do
      it 'ユーザーを削除する' do
        delete('/api/users')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'トークンなしでのリクエストの場合' do
      it '未認証を返す' do
        delete('/api/users', headers: unauthorized_header)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

end
