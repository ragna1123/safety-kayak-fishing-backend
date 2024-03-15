# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripReturnsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user) } # 有効な認証トークンを含むヘッダーを想定
  let(:trip) { create(:trip, user:, departure_time: 2.hours.ago) }

  describe 'PUT /api/trips/:id/return' do
    context '自分のトリップの帰投報告を更新する場合' do
      let(:new_return_details) { '無事帰還しました' }

      before do
        put "/api/trips/#{trip.id}/return", params: { trip: { return_details: new_return_details } }, headers:
      end

      it '帰投報告を更新する' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('帰投報告が登録されました')
        updated_trip = Trip.find(trip.id)
        expect(updated_trip.return_details).to eq(new_return_details)
      end
    end

    context '他のユーザーのトリップの帰投報告を更新しようとする場合' do
      let(:other_user) { create(:user) }
      let(:other_users_trip) { create(:trip, user: other_user) }

      before do
        put "/api/trips/#{other_users_trip.id}/return", params: { trip: { return_details: '無事帰還しました' } },
                                                        headers:
      end

      it 'ステータスコード403を返す' do
        expect(response).to have_http_status(:forbidden)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('操作が許可されていません')
      end
    end
  end
end
