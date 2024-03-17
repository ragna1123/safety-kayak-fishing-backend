# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripHistoriesController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user) } # valid_headersは、有効な認証トークンを含むヘッダーを返すヘルパーメソッドを想定

  # ユーザーが作成したトリップの履歴を取得する GET /api/trips/histories
  describe 'GET /api/trips/histories' do
    context 'リクエストが有効な場合' do
      let!(:trip1) { create(:trip, user:, departure_time: 3.days.ago, estimated_return_time: 2.day.ago) }
      let!(:trip2) { create(:trip, user:, departure_time: 5.day.ago, estimated_return_time: 4.day.ago) }

      before do
        get '/api/trips/histories', headers:
      end

      it 'ユーザーが作成したトリップの履歴を取得する' do
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        trips = json_response['data']

        expect(trips.size).to eq(2)

        # トリップの内容を検証
        expect(trips.any? { |t| t['details'] == trip1.details }).to be true
        expect(trips.any? { |t| t['details'] == trip2.details }).to be true
      end
    end

    context '過去の出船予定が存在しない場合' do
      before do
        get '/api/trips/histories', headers:
      end

      it '空の配列を返す' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('過去の出船予定はありません')
      end
    end

    context 'ユーザーが未認証の場合' do
      before do
        get '/api/trips/histories', headers: {} # 空のヘッダーを送信
      end

      it 'ステータスコード 401 を返す' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/trips/:id/history' do
    let!(:trip) { create(:trip, user:, departure_time: 3.days.ago, estimated_return_time: 2.day.ago) }
    let!(:weather_data1) { create(:weather_data) }
    let!(:weather_data2) { create(:weather_data) }
    let!(:weather_data3) { create(:weather_data) }
    let!(:trip_weather1) { create(:trip_weather, trip:, weather_data: weather_data1) }
    let!(:trip_weather2) { create(:trip_weather, trip:, weather_data: weather_data2) }
    let!(:trip_weather3) { create(:trip_weather, trip:, weather_data: weather_data3) }

    context 'トリップが存在し、ユーザーが認証されている場合' do
      before { get "/api/trips/#{trip.id}/history", headers: }

      it 'トリップと天気の履歴を取得する' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['data']['id']).to eq(trip.id)
        expect(json_response['weather_histories'].size).to eq(3)
      end
    end

    context 'トリップが存在しない場合' do
      before { get '/api/trips/0/history', headers: }

      it 'エラーメッセージを返す' do
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('トリップが見つかりません')
      end
    end

    context 'ユーザーが認証されていない場合' do
      let(:invalid_headers) { { 'Authorization' => nil } }
      before { get "/api/trips/#{trip.id}/history", headers: invalid_headers }

      it 'ステータスコード401を返す' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
