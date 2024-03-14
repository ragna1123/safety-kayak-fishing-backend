# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ユーザーログイン', type: :request do
  let(:user) { create(:user) }

  let(:valid_params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  let(:invalid_email_params) do
    {
      user: {
        email: 'wrong@example.com',
        password: user.password
      }
    }
  end

  let(:invalid_password_params) do
    {
      user: {
        email: user.email,
        password: 'wrongpassword'
      }
    }
  end

  describe 'POST /api/users/login' do
    before { user } # ユーザーを事前に作成

    context 'パラメータが正しい場合' do
      before do
        post '/api/users/login', params: valid_params
      end

      it 'ログインに成功' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'メールアドレスが正しくない場合' do
      before do
        post '/api/users/login', params: invalid_email_params
      end

      it 'ログインに失敗' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'エラーメッセージを返す' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('メールアドレスまたはパスワードが正しくありません')
      end
    end

    context 'パスワードが正しくない場合' do
      before do
        post '/api/users/login', params: invalid_password_params
      end

      it 'ログインに失敗' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'エラーメッセージを返す' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('メールアドレスまたはパスワードが正しくありません')
      end
    end
  end
end
