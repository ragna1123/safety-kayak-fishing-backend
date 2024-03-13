require 'rails_helper'

RSpec.describe 'Trips API', type: :request do
  let(:user) { create(:user) }
  let(:trip_attributes) { attributes_for(:trip, user_id: user.id) }
  let(:invalid_trip_attributes) { attributes_for(:trip, location_data: { latitude: '', longitude: '' }, departure_time: '', estimated_return_time: '', details: '') }
  let(:headers) { valid_headers(user) }

  describe 'POST /api/trips 出船予定の登録' do
    context 'リクエストが有効な場合' do
      before { post '/api/trips', params: { trip: trip_attributes }, headers: headers }

      it '出船予定を作成する' do
        expect(response).to have_http_status(201)
        expect(json['message']).to match(/出船予定が登録されました/)
      end
    end

    context 'リクエストが無効な場合' do
      before { post '/api/trips', params: { trip: invalid_trip_attributes }, headers: headers }

      it 'ステータスコード 422 を返す' do
        expect(response).to have_http_status(422)
        expect(json['message']).to match(/リクエストの値が無効です/)
      end
    end

    context 'ユーザーが未認証の場合' do
      before { post '/api/trips', params: { trip: trip_attributes }, headers: {} }

      it 'ステータスコード 401 を返す' do
        expect(response).to have_http_status(401)
        expect(json['message']).to match(/トークンが見つからないか無効です/)
      end
    end
  end

  # JSONをパースするヘルパーメソッド
  def json
    JSON.parse(response.body)
  end
end


