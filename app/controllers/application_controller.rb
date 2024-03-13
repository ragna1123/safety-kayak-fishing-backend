# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :jwt_authenticate

  private

  def jwt_authenticate
    auth_header = request.headers['Authorization']
    if auth_header.present? && auth_header.split(' ').size == 2
      scheme, token = auth_header.split(' ')
      if scheme.downcase == 'bearer'
        begin
          decoded_token = decode_jwt(token)
          @current_user = User.find_by(id: decoded_token['user_id'])
          render_unauthorized unless @current_user
        rescue JWT::DecodeError => e
          render json: { status: 'error', message: "トークンのデコードに失敗しました: #{e.message}" }, status: :unauthorized
        end
      else
        render_unauthorized
      end
    else
      render_unauthorized
    end
  end

  def decode_jwt(token)
    JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' }).first
  end

  def render_unauthorized
    render json: { status: 'error', message: 'トークンが無効です' }, status: :unauthorized
  end
end
