# frozen_string_literal: true

# app/controllers/line_auth_controller.rb
class LineAuthController < ApplicationController
  before_action :jwt_authenticate
  include HTTParty

  def callback
    code = params[:code]

    # アクセストークンの取得
    response = self.class.post('https://api.line.me/oauth2/v2.1/token', {
                                 body: {
                                   'grant_type' => 'authorization_code',
                                   'code' => code,
                                   'redirect_uri' => ENV['LINE_LOGIN_CALLBACK_URL'],
                                   'client_id' => ENV['LINE_LOGIN_CHANNEL_ID'],
                                   'client_secret' => ENV['LINE_LOGIN_CHANNEL_SECRET']
                                 },
                                 headers: { 'Content-Type' => 'application/x-www-form-urlencoded' }
                               })

    return render json: { error: 'LINE認証に失敗しました。' }, status: :unauthorized unless response.success?

    access_token = response.parsed_response['access_token']

    # ユーザープロフィールの取得
    response = self.class.get('https://api.line.me/v2/profile', {
                                headers: { 'Authorization' => "Bearer #{access_token}" }
                              })

    return render json: { error: 'ユーザープロフィールの取得に失敗しました。' }, status: :bad_request unless response.success?

    line_id = response.parsed_response['userId']

    if line_id.present?
      @current_user.update(line_id:)
      render json: { message: 'LINEアカウントが正常にリンクされました。' }, status: :ok
    else
      render json: { error: 'LINEアカウントのリンクに失敗しました。' }, status: :bad_request
    end
  end
end
