# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user) } # 有効な認証トークンを含むヘッダーを想定
  let(:trip) { create(:trip, user: user) }

  describe 'DELETE /api/trips/:id' do
    context 'リクエストが有効な場合' do
      before do
          delete "/api/trips/#{trip.id}", headers: headers
      end

      it '出船予定を削除する' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('出船予定が削除されました')
      end
    end

    context "無効なIDを指定した場合" do
      before do
        delete "/api/trips/0", headers: headers
      end

      it 'ステータスコード404を返す' do
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('出船予定が見つかりません')
      end
    end
    

    context '他のユーザーの出船予定を削除しようとする場合' do
      let(:other_user) { create(:user) }
      let(:other_users_trip) { create(:trip, user: other_user) }

      before do
        delete "/api/trips/#{other_users_trip.id}", headers: headers
      end

      it 'ステータスコード403を返す' do
        expect(response).to have_http_status(:forbidden)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to eq('他人の出船予定は削除できません')
      end
    end
  end
end
