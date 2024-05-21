# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FavoriteLocationsController, type: :request do
  let(:user) { create(:user) }
  let(:token) { create_token_for(user) }
  let(:unauthorized_header){{ 'Cookie' => "jwt=#{""}" }}
  let(:favorite_location) { create(:favorite_location, user:) }
  let(:location) { create(:location) }
  let(:favorite_location_attributes) do
    {
      location_name: favorite_location.location_name,
      description: favorite_location.description,
      location_data: {
        latitude: location.latitude,
        longitude: location.longitude
      }
    }
  end

  before do
    # ここでクッキーをセットしている
    set_jwt_cookies(token)
  end

  describe 'POST /api/favorite_locations' do
    context 'リクエストが有効な場合' do
      before do
        post '/api/favorite_locations', params: { favorite_location: favorite_location_attributes }, headers:
      end

      it 'お気に入りの出船予定を登録する' do
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('お気に入りの出船地点が登録されました')
      end
    end

    context 'リクエストが無効な場合' do
      before do
        post '/api/favorite_locations',
             params: { favorite_location: { location_name: 'テスト地点', description: 'テスト説明', location_data: { latitude: nil, longitude: nil } } }
      end

      it 'ステータスコード 422 を返す' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'ユーザーが未認証の場合' do
      before do
        post '/api/favorite_locations', params: { favorite_location: favorite_location_attributes }, headers: unauthorized_header
      end

      it 'ステータスコード 401 を返す' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/favorite_locations' do
    let!(:favorite_location1) { create(:favorite_location, user:) }
    let!(:favorite_location2) { create(:favorite_location, user:) }

    context 'リクエストが有効な場合' do
      before do
        get '/api/favorite_locations'
      end

      it 'お気に入りの出船地点を取得する' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['data'].length).to eq(2)
        expect(json_response['data'].map { |l| l['id'] }).to include(favorite_location1.id, favorite_location2.id)
      end
    end

    context 'ユーザーが未認証の場合' do
      before do
        get '/api/favorite_locations', headers: unauthorized_header
      end

      it 'ステータスコード 401 を返す' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/favorite_locations/:id' do
    let(:favorite_location) { create(:favorite_location, user:) }
    context 'リクエストが有効な場合' do
      before do
        delete "/api/favorite_locations/#{favorite_location.id}"
      end

      it 'お気に入りの出船地点を削除する' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('お気に入りの出船地点が削除されました')
      end
    end

    context '存在しないお気に入り地点IDを指定した場合' do
      before do
        delete '/api/favorite_locations/0'
      end

      it 'ステータスコード 404 を返す' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'ユーザーが未認証の場合' do
      before do
        delete "/api/favorite_locations/#{favorite_location.id}", headers: unauthorized_header
      end

      it 'ステータスコード 401 を返す' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
