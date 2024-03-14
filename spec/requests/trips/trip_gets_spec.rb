# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user) } # valid_headersは、有効な認証トークンを含むヘッダーを返すヘルパーメソッドを想定

  # 出船予定一覧を取得する GET /api/trips
  describe 'GET /api/trips' do
    let(:user) { create(:user) }
    let(:headers) { valid_headers(user) }

    context 'リクエストが有効な場合' do
      let!(:trip1) { create(:trip, user:) }
      let!(:trip2) { create(:trip, user:) }

      before do
        get '/api/trips', headers:
      end

      it '出船予定一覧を取得する' do
        expect(response).to have_http_status(:ok)

        # レスポンスボディからトリップ情報を取得
        json_response = JSON.parse(response.body)
        trips = json_response['data'] # ネストされた"data"キーからトリップの配列を取得

        # トリップの数を検証
        expect(trips.size).to eq(2)

        # トリップの内容を検証
        expect(trips[0]['id']).to eq(trip1.id)
        expect(trips[1]['id']).to eq(trip2.id)
      end
    end

    context '出船予定が存在しない場合' do
      before do
        get '/api/trips', headers:
      end

      it '空の配列を返す' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['data']).to be_empty
      end
    end

    context 'ユーザーが未認証の場合' do
      before do
        get '/api/trips', headers: {} # 空のヘッダーを送信
      end

      it 'ステータスコード 401 を返す' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context '他のユーザーの出船予定を取得しようとする場合' do
      let(:other_user) { create(:user) }
      let!(:other_users_trip) { create(:trip, user: other_user) }

      before do
        get '/api/trips', headers:
      end

      it '他のユーザーの出船予定は含まれない' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        trips = json_response['data']
        expect(trips).not_to include(other_users_trip.as_json)
      end
    end
  end

  # 出船予定の詳細を取得する GET /api/trips/:id
  describe 'GET /api/trips/:id' do
    let(:user) { create(:user) }
    let(:headers) { valid_headers(user) }
    let(:trip) { create(:trip, user:) }

    context '特定の出船予定が正常に取得できる場合' do
      before do
        get "/api/trips/#{trip.id}", headers:
      end

      it '出船予定の詳細を取得する' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['data']['id']).to eq(trip.id)
      end
    end

    context '要求された出船予定が存在しない場合' do
      let(:nonexistent_trip_id) { trip.id + 1 }

      before do
        get "/api/trips/#{nonexistent_trip_id}", headers:
      end

      it 'ステータスコード404を返す' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'ユーザーが未認証の場合' do
      before do
        get "/api/trips/#{trip.id}", headers: {}
      end

      it 'ステータスコード401を返す' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'ユーザーが他のユーザーの出船予定を取得しようとする場合' do
      let(:other_user) { create(:user) }
      let(:other_users_trip) { create(:trip, user: other_user) }

      before do
        get "/api/trips/#{other_users_trip.id}", headers:
      end

      it 'ステータスコード403を返す' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
