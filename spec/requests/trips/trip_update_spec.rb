# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripsController, type: :request do
  let(:user) { create(:user) }
  let(:token) { create_token_for(user) }
  let(:unauthorized_header){{ 'Cookie' => "jwt=#{""}" }}
  let(:location) { create(:location) }
  let(:trip) { create(:trip, user:, location:) }
  let(:new_attributes) do
    {
      departure_time: Time.zone.now + 9.hours,
      estimated_return_time: Time.zone.now + 12.hours,
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

  describe 'PUT /api/trips/:id' do
    context 'リクエストが有効な場合' do
      before do
        put "/api/trips/#{trip.id}", params: { trip: new_attributes }
      end

      it '出船予定を更新し、成功メッセージを返す' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('出船予定が更新されました')
      end
    end

    context '他のユーザーの出船予定を更新しようとした場合' do
      let(:other_user) { create(:user) }
      let(:other_users_trip) { create(:trip, user: other_user) }

      before do
        put "/api/trips/#{other_users_trip.id}", params: { trip: new_attributes }
      end

      it 'ステータスコード403を返し、アクセスを拒否する' do
        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)['message']).to eq('他人の出船予定は操作できません')
      end
    end

    context '他の予定と時間が重複する場合' do
      let(:overlapping_trip) do
        create(:trip, user:, departure_time: new_attributes[:departure_time] - 1.hour,
                      estimated_return_time: new_attributes[:estimated_return_time] - 1.hour)
      end

      before do
        overlapping_trip # 重複するトリップを事前に作成
        put "/api/trips/#{trip.id}", params: { trip: new_attributes }
      end

      it '出船予定は更新されず、エラーメッセージを返す' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('出船時間が被っています')
      end
    end
  end
end
