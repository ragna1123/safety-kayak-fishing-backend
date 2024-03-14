# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user) } # valid_headersは、有効な認証トークンを含むヘッダーを返すヘルパーメソッドを想定
  let(:location) { create(:location) }
  let(:valid_attributes) do
    {
      departure_time: '2024-03-15 08:00:00',
      estimated_return_time: '2024-03-15 18:00:00',
      details: '東京湾での釣り',
      location_data: {
        latitude: location.latitude,
        longitude: location.longitude
      }
    }
  end

  describe 'POST /api/trips' do
    context 'リクエストが有効な場合' do
      before do
        post '/api/trips', params: { trip: valid_attributes }, headers:
      end

      it '出船予定を作成する' do
        expect(response).to have_http_status(:created)
      end
    end

    context '位置情報が無い場合' do
      before do
        post '/api/trips', params: { trip: valid_attributes.except(:location_data) }, headers:
      end

      it 'ステータスコード 422 を返す' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to match(/位置情報が必要です/)
      end
    end

    context 'ユーザーが未認証の場合' do
      before do
        post '/api/trips', params: { trip: valid_attributes }, headers: {}
      end

      it 'ステータスコード 401 を返す' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
