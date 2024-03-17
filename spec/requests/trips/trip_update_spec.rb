# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user) } # 有効な認証トークンを含むヘッダーを想定
  let(:location) { create(:location) }

  describe 'PUT /api/trips/:id' do
    context 'リクエストが有効な場合' do
      let(:trip) { create(:trip, user: user) }
      let(:new_location) { create(:location) }
      let(:new_attributes) do
        {
          departure_time: '2024-03-15T09:00:00.000Z',
          estimated_return_time: '2024-03-15T19:00:00.000Z',
          details: '東京湾での釣り',
          location_data: {
            latitude: new_location.latitude,
            longitude: new_location.longitude
          }
        }
      end

      before do
        put "/api/trips/#{trip.id}", params: { trip: new_attributes }, headers: headers
      end

      it '出船予定を更新する' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('出船予定が更新されました')
      end
      
    end

    context '他のユーザーの出船予定を更新しようとする場合' do
      let(:other_user) { create(:user) }
      let(:other_users_trip) { create(:trip, user: other_user) }
      let(:new_attributes) { attributes_for(:trip) } # 新しい出船予定の属性
      
      before do
        put "/api/trips/#{other_users_trip.id}", params: { trip: new_attributes }, headers: headers
      end
      
      it 'ステータスコード403を返す' do
        expect(response).to have_http_status(:forbidden)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('他人の出船予定は更新できません')
      end
    end
  end
end
