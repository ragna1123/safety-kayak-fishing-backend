require 'rails_helper'

RSpec.describe TripReturnsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user) }
  let(:active_trip) { create(:trip, user: user, departure_time: 2.hours.ago, estimated_return_time: 1.hour.from_now) }
  let(:inactive_trip) { create(:trip, user: user, departure_time: 1.hours.from_now, estimated_return_time: 2.hours.from_now) }

  describe 'PUT /api/trips/:id/return' do
    context 'トリップが出航している場合' do
      let(:return_details) { '無事帰還しました' }

      before do
        put "/api/trips/#{active_trip.id}/return", params: { trip: { return_details: return_details } }, headers: headers
      end

      it '帰投報告が更新される' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('帰投報告が登録されました')
        expect(active_trip.reload.return_details).to eq(return_details)
      end
    end

    context 'トリップが出航していない場合' do
      before do
        put "/api/trips/#{inactive_trip.id}/return", params: { trip: { return_details: '無事帰還しました' } }, headers: headers
      end

      it '帰投報告が更新されない' do
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('出航していないトリップは帰投報告できません')
      end
    end
  end
end
