# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies

  def jwt_authenticate
    # クッキーからトークンを取得し、ログ出力
    token = cookies[:jwt]

    Rails.logger.info "Signed token: #{token.inspect}"
    Rails.logger.info "Raw token from cookies: #{cookies[:jwt].inspect}"
  
    if token
      begin
        decoded_token = decode_jwt(token)
        @current_user = User.find_by(id: decoded_token['user_id'])
        # p @current_user
        render_unauthorized unless @current_user
      rescue JWT::DecodeError => e
        render json: { status: 'error', message: "トークンのデコードに失敗しました: #{e.message}" }, status: :unauthorized
      end
    else
      render_unauthorized
    end
  end
  

  def decode_jwt(token)
    JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' }).first
  end

  def render_unauthorized
    render json: { status: 'error', message: 'トークンが見つからないか無効です' }, status: :unauthorized
  end
end
