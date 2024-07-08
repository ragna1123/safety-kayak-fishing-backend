# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :jwt_authenticate, only: %i[show update destroy]

  # ユーザー登録 API POST /api/users
  def create
    user = User.new(user_params)
    if user.save
      render json: { status: 'success', message: 'ユーザーの登録に成功しました' }, status: :created
    else
      render json: { status: 'error', message: 'ユーザーの登録に失敗しました', data: user.errors }, status: :unprocessable_entity
    end
  end

  # ログイン API POST /api/login
  def login
    user = User.find_by(email: user_params[:email])
    if user&.authenticate(user_params[:password])
      token = jwt_create_token(user)

      # HTTP Onlyクッキーにトークンを保存
      cookies[:jwt] = { value: token, expires: 1.month.from_now, httponly: true, secure: true}
      render json: { user: }, status: :ok
    else
      render json: { status: 'error', message: 'メールアドレスまたはパスワードが正しくありません' }, status: :unauthorized
    end
  end

  # ユーザー情報取得 API GET /api/users
  def show
    if @current_user
      render json: {
        user: {
          id: @current_user.id,
          username: @current_user.username,
          email: @current_user.email,
          profile_image_url: @current_user.profile_image_url
        }
      }, status: :ok
    else
      render json: { status: 'error', message: '認証に失敗しました' }, status: :unauthorized
    end
  end

  # ユーザー情報更新 API PUT /api/users
  def update
    if @current_user.update(user_params)
      render json: { status: 'success', message: 'ユーザー情報を更新しました' }, status: :ok
    else
      render json: { status: 'error', message: 'ユーザー情報の更新に失敗しました' }, status: :unprocessable_entity
    end
  end

  # ユーザー削除 API DELETE /api/users
  def destroy
    if @current_user.destroy
      render json: { status: 'success', message: 'ユーザーを削除しました' }, status: :ok
    else
      render json: { status: 'error', message: 'ユーザーの削除に失敗しました' }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :line_id, :profile_image_url)
  end

  def jwt_create_token(user)
    payload = { user_id: user.id }
    JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
  end
end
