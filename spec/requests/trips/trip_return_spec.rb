# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripReturnsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user) }
  let(:active_trip) { create(:trip, user:, departure_time: 2.hours.ago, estimated_return_time: 1.hour.from_now) }
  let(:inactive_trip) do
    create(:trip, user:, departure_time: 1.hours.from_now, estimated_return_time: 2.hours.from_now)
  end

  describe 'GET /api/trips/returned' do
    context '帰投報告が存在する場合' do
      let!(:returned_trip) { create(:trip, user:, return_time: Time.zone.now - 1.day) }

      before do
        get '/api/trips/returned', headers:
      end

      it '帰投報告のトリップ一覧が返される' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['data']).not_to be_empty
        expect(json_response['data'].first['id']).to eq(returned_trip.id)
      end
    end

    context '帰投報告が存在しない場合' do
      before do
        get '/api/trips/returned', headers:
      end

      it '適切なメッセージが返される' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('帰投報告はありません')
      end
    end
  end

  describe 'GET /api/trips/unreturned' do
    context '未帰投報告が存在する場合' do
      let!(:returned_trip) { create(:trip, user:, return_time: nil) }

      before do
        get '/api/trips/unreturned', headers:
      end

      it '未帰投報告のトリップ一覧が返される' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['data']).not_to be_empty
        expect(json_response['data'].first['id']).to eq(returned_trip.id)
      end
    end

    context '未帰投報告が存在しない場合' do
      before do
        get '/api/trips/unreturned', headers:
      end

      it '適切なメッセージが返される' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('未帰投報告はありません')
      end
    end
  end

  describe 'PUT /api/trips/:id/return' do
    context 'トリップが出航している場合' do
      let(:return_details) { '無事帰還しました' }

      before do
        put "/api/trips/#{active_trip.id}/return", params: { trip: { return_details: } },
                                                   headers:
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
        put "/api/trips/#{inactive_trip.id}/return", params: { trip: { return_details: '無事帰還しました' } }, headers:
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
