# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TripsController, type: :request do
  # テスト用のユーザーとヘッダーを設定
  let(:user) { create(:user) }
  let(:token) { create_token_for(user) }
  let(:unauthorized_header){{ 'Cookie' => "jwt=#{""}" }}

  # アクティブなトリップと非アクティブなトリップを事前に作成
  let!(:active_trip) { create(:trip, user:, departure_time: 1.hour.ago, estimated_return_time: 1.hour.from_now) }
  let!(:inactive_trip) { create(:trip, user:, departure_time: 2.days.ago, estimated_return_time: 1.day.ago) }

  before do
    set_jwt_cookies(token)
  end

  describe 'GET /api/trips/active' do
    context 'ユーザーがアクティブなトリップを持っている場合' do
      before do
        get '/api/trips/active'
      end

      it '成功ステータスが返される' do
        expect(response).to have_http_status(:ok)
      end

      it 'アクティブなトリップが返される' do
        expect(JSON.parse(response.body)['data']['trip']['id']).to eq(active_trip.id)
      end
    end

    context 'ユーザーがアクティブなトリップを持っていない場合' do
      before do
        # アクティブなトリップを非アクティブに更新
        active_trip.update(departure_time: 2.days.ago, estimated_return_time: 1.day.ago)
        get '/api/trips/active'
      end

      it '成功ステータスが返される' do
        expect(response).to have_http_status(:ok)
      end

      it '「出船中の予定はありません」というメッセージが返される' do
        expect(JSON.parse(response.body)['message']).to eq('出船中の予定はありません')
      end
    end
  end
end
