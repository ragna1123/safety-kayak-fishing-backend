require 'rails_helper'

RSpec.describe 'ユーザーログイン', type: :request do
  let(:user_params) do
    {
      user: {
        email: 'test@example.com',
        password: 'password123'
      }
    }
  end

  describe 'POST /api/users/login' do
    before do
      # ユーザーを作成する
      User.create!(username: 'testuser', email: 'test@example.com', password: 'password123',
                   password_confirmation: 'password123')
    end

    context 'パラメータが正しい場合' do
      before do
        post '/api/users/login', params: user_params
      end

      it 'ログインに成功' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'パラメータが正しくない場合' do
      before do
        post '/api/users/login', params: { user: { email: 'testexample.com', password: 'password123' } }
      end

      it 'ログインに失敗' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'エラーメッセージを返す' do
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('メールアドレスまたはパスワードが正しくありません')
      end
    end

    context '存在しないユーザーの場合' do
      before do
        post '/api/users/login', params: { user: { email: 'nonexistent@example.com', password: 'password123' } }
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
        post '/api/users/login', params: { user: { email: 'test@example.com', password: 'invalidpassword' } }
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
