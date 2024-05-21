# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripsController, type: :request do
  let(:user) { create(:user) }
  let(:token) { create_token_for(user) }
  let(:unauthorized_header){{ 'Cookie' => "jwt=#{""}" }}

  before do
    set_jwt_cookies(token)
  end

  # 出船予定一覧を取得する GET /api/trips
  describe 'GET /api/trips' do
    context 'リクエストが有効な場合' do
      let!(:trip1) { create(:trip, user:) }
      let!(:trip2) { create(:trip, user:) }

      before do
        get '/api/trips'
      end

      it '出船予定一覧を取得する' do
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        trips = json_response['data']

        expect(trips.size).to eq(2)
      end
    end

    context '出船予定が存在しない場合' do
      before do
        get '/api/trips'
      end

      it '空の配列を返す' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['data']).to be_empty
      end
    end

    context 'ユーザーが未認証の場合' do
      before do
        get '/api/trips', headers: unauthorized_header 
      end

      it 'ステータスコード 401 を返す' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context '他のユーザーの出船予定を取得しようとする場合' do
      let(:other_user) { create(:user) }
      let!(:other_users_trip) { create(:trip, user: other_user) }

      before do
        get '/api/trips'
      end

      it '他のユーザーの出船予定は含まれない' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        trips = json_response['data']
        expect(trips).not_to include(other_users_trip.as_json)
      end
    end

    context '未来の出航予定が存在する場合' do
      let!(:future_trip1) { create(:trip, user:, departure_time: 1.day.from_now) }
      let!(:future_trip2) { create(:trip, user:, departure_time: 2.days.from_now) }

      before do
        get '/api/trips'
      end

      it '未来の出航予定のみが含まれる' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        trips = json_response['data']
        expect(trips.size).to eq(2)
        expect(trips.map { |t| t['trip']['id'] }).to match_array([future_trip1.id, future_trip2.id])
      end
    end

    context '過去の出航予定のみが存在する場合' do
      let!(:past_trip) { create(:trip, user:, departure_time: 1.day.ago) }

      before do
        get '/api/trips'
      end

      it '空の配列が返される' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['data']).to be_empty
      end
    end

    context '出航予定が降順で返されること' do
      let!(:future_trip1) { create(:trip, user:, departure_time: 1.day.from_now) }
      let!(:future_trip2) { create(:trip, user:, departure_time: 2.days.from_now) }

      before do
        get '/api/trips'
      end

      it '予定が降順で返される' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        trips = json_response['data']
        expect(trips.first['trip']['id']).to eq(future_trip2.id)
        expect(trips.last['trip']['id']).to eq(future_trip1.id)
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
        get "/api/trips/#{trip.id}"
      end

      it '出船予定の詳細を取得する' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['data']['trip']['id']).to eq(trip.id)
      end
    end

    context '要求された出船予定が存在しない場合' do
      let(:nonexistent_trip_id) { trip.id + 1 }

      before do
        get "/api/trips/#{nonexistent_trip_id}"
      end

      it 'ステータスコード404を返す' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'ユーザーが未認証の場合' do
      before do
        get "/api/trips/#{trip.id}", headers: unauthorized_header
      end

      it 'ステータスコード401を返す' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'ユーザーが他のユーザーの出船予定を取得しようとする場合' do
      let(:other_user) { create(:user) }
      let(:other_users_trip) { create(:trip, user: other_user) }

      before do
        get "/api/trips/#{other_users_trip.id}"
      end
      it 'ステータスコード403を返す' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
