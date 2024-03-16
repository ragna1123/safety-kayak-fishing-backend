# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripHistoriesController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user) } # valid_headersは、有効な認証トークンを含むヘッダーを返すヘルパーメソッドを想定

  # ユーザーが作成したトリップの履歴を取得する GET /api/trips/histories
  describe 'GET /api/trips/histories' do
    context 'リクエストが有効な場合' do
      let!(:trip1) { create(:trip, user: user, departure_time: 3.days.ago, estimated_return_time: 2.day.ago) }
      let!(:trip2) { create(:trip, user: user, departure_time: 5.day.ago, estimated_return_time: 4.day.ago) }
      
      before do
        get '/api/trips/histories', headers: headers
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
        get '/api/trips/histories', headers: headers
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
end