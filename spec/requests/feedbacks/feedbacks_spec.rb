# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeedbacksController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers(user) }

  describe 'POST /api/feedbacks' do
    let(:valid_params) { { feedback: attributes_for(:feedback) } }

    context 'リクエストが有効な場合' do
      before do
        post '/api/feedbacks', params: valid_params, headers:
      end

      it 'フィードバックが作成されること' do
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('success')
        expect(json_response['message']).to eq('フィードバックが登録されました')
      end
    end

    context 'リクエストが無効な場合' do
      before do
        post '/api/feedbacks', params: { feedback: { title: '', comment: '' } }, headers:
      end

      it 'ステータスコード422が返されること' do
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('error')
        expect(json_response['message']).to include('フィードバックの登録に失敗しました')
      end
    end

    context 'ユーザーが未認証の場合' do
      before do
        post '/api/feedbacks', params: valid_params, headers: {}
      end

      it 'ステータスコード401が返されること' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
