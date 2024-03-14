require 'rails_helper'

RSpec.describe 'Trips API', type: :request do
  let(:user) { create(:user) }
  let(:trip_attributes) { attributes_for(:trip, user_id: user.id) }
  let(:headers) { user ? valid_headers(user) : {} }
  let(:json) { JSON.parse(response.body) }

  describe 'POST /api/trips 出船予定の登録' do
    let(:trip_params) { { trip: trip_attributes } }
    
    subject { post '/api/trips', params: trip_params, headers: headers }

    context 'リクエストが有効な場合' do
      it '出船予定を作成する' do
        subject
        expect(response).to have_http_status(201)
        expect(json['message']).to match(/出船予定が登録されました/)
      end
    end

    context '位置情報が無い場合' do
      let(:trip_attributes) do
        attributes_for(:trip, user_id: user.id, location_data: { latitude: '', longitude: '' })
      end
      
      it 'ステータスコード 422 を返す' do
        subject
        expect(response).to have_http_status(422)
        expect(json['message']).to match(/位置情報が必要です/)
      end
    end

    context '位置情報が無効な値の場合' do
      let(:trip_attributes) do
        attributes_for(:trip, user_id: user.id, location_data: { latitude: '999.999', longitude: '999.999' })
      end
      
      it 'ステータスコード 422 を返す' do
        subject
        expect(response).to have_http_status(422)
        expect(json['message']).to match(/位置情報が無効です/)
      end
    end

    context 'その他のリクエスト値が無効な場合' do
      let(:trip_attributes) do
        attributes_for(:trip, user_id: user.id, departure_time: '', estimated_return_time: '', details: '')
      end
      
      it 'ステータスコード 422 を返す' do
        subject
        expect(response).to have_http_status(422)
        expect(json['message']).to match(/リクエストの値が無効です/)
      end
    end

    context 'ユーザーが未認証の場合' do
      let(:headers) { {} }

      it 'ステータスコード 401 を返す' do
        subject
        expect(response).to have_http_status(401)
        expect(json['message']).to match(/トークンが見つからないか無効です/)
      end
    end
  end
end


