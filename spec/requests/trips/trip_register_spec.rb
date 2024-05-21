# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripsController, type: :request do
  let(:user) { create(:user) }
  let(:token) { create_token_for(user) }
  let(:unauthorized_header){{ 'Cookie' => "jwt=#{""}" }}
  let(:location) { create(:location) }
  let(:valid_attributes) do
    {
      departure_time: Time.zone.now + 3.hours, # 現在時刻から3時間後
      estimated_return_time: Time.zone.now + 8.hours, # 現在時刻から8時間後
      details: '東京湾での釣り',
      location_data: {
        latitude: location.latitude,
        longitude: location.longitude
      }
    }
  end
  
  before do
    set_jwt_cookies(token)
  end

  describe 'POST /api/trips' do
    context 'リクエストが有効な場合' do
      before do
        post '/api/trips', params: { trip: valid_attributes }
      end

      it '出船予定を作成する' do
        expect(response).to have_http_status(:created)
      end
    end

    context '位置情報が無い場合' do
      before do
        post '/api/trips', params: { trip: valid_attributes.except(:location_data) }
      end

      it 'ステータスコード 422 を返す' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to match(/位置情報が必要です/)
      end
    end

    context 'ユーザーが未認証の場合' do
      before do
        post '/api/trips', params: { trip: valid_attributes }, headers: unauthorized_header
      end

      it 'ステータスコード 401 を返す' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context '出発時間が帰還予定時間より後の場合' do
      let(:invalid_time_attributes) do
        {
          departure_time: Time.zone.now + 8.hours, # 現在時刻から3時間後
          estimated_return_time: Time.zone.now + 3.hours, # 現在時刻から8時間後
          details: '東京湾での釣り',
          location_data: {
            latitude: location.latitude,
            longitude: location.longitude
          }
        }
      end

      before do
        post '/api/trips', params: { trip: invalid_time_attributes }
      end

      it 'ステータスコード 422 を返す' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to match(/出船予定日が無効です/)
      end
    end

    context '出発時間と帰還予定時間が提供されていない場合' do
      let(:no_time_attributes) do
        {
          details: '東京湾での釣り',
          location_data: {
            latitude: location.latitude,
            longitude: location.longitude
          }
        }
      end

      before do
        post '/api/trips', params: { trip: no_time_attributes }
      end

      it 'ステータスコード 422 を返す' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to match(/出発時間と帰還予定時間が必要です/)
      end
    end

    context '出発時間が現在時刻より過去の場合' do
      let(:past_time_attributes) do
        {
          departure_time: (Time.zone.now - 1.hour),
          estimated_return_time: (Time.zone.now + 1.hour),
          details: '東京湾での釣り',
          location_data: {
            latitude: location.latitude,
            longitude: location.longitude
          }
        }
      end
      before do
        post '/api/trips', params: { trip: past_time_attributes }
      end

      it 'ステータスコード 422 を返す' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to match(/出船予定日が無効です/)
      end
    end

    context '他の予定と時間が重複する場合' do
      # 他の予定と時間的に重複する出船予定
      let(:overlapping_attributes) do
        {
          departure_time: valid_attributes[:departure_time] - 1.hour,
          estimated_return_time: valid_attributes[:estimated_return_time] - 2.hours,
          details: '別の東京湾での釣り',
          location_data: valid_attributes[:location_data]
        }
      end

      before do
        # 最初に有効な出船予定を作成
        post('/api/trips', params: { trip: valid_attributes })

        # 重複する出船予定を作成しようとする
        post '/api/trips', params: { trip: overlapping_attributes }
      end

      it '新しい出船予定は作成されない' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('出船時間が被っています')
        expect(user.trips.count).to eq(1) # 最初のトリップのみが作成されている
      end
    end
  end

end
