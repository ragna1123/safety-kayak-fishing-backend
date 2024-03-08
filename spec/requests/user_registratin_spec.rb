# spec/requests/user_registration_spec.rb
require 'rails_helper'

RSpec.describe 'User Registration', type: :request do
  let(:user_params) do
    {
      user: {
        username: 'user',
        email: 'user@example.com',
        password: 'password',
        password_confirmation: 'password'
      }
    }
  end

  describe 'POST /api/users' do
    context 'with valid parameters' do
      before do
        post '/api/users', params: user_params
      end

      it 'creates a new user' do
        expect(response).to have_http_status(:created)
      end

      it 'returns a JWT token' do
        expect(json['token']).not_to be_nil
      end
    end

    context 'with invalid parameters' do
      before do
        post '/api/users', params: { user: { email: 'user', password: 'password', password_confirmation: 'password' } }
      end

      it 'does not create a new user' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not return a JWT token' do
        expect(json['token']).to be_nil
      end
    end
  end
end
