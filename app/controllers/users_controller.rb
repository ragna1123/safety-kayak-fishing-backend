class UsersController < ApplicationController
  before_action :jwt_authenticate, only: [:show, :update, :destroy]
  
  def create
    user = User.new(user_params)
    if user.save
      render json: { status: 'success', message: 'ユーザーの登録に成功しました' }, status: :created
    else
      render json: { status: 'error', message: 'ユーザーの登録に失敗しました', data: user.errors }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: user_params[:email])
    if user && user.authenticate(user_params[:password])
      render json: { user: user, token: jwt_create_token(user) }, status: :ok
    else
      render json: { status: 'error', message: 'メールアドレスまたはパスワードが正しくありません' }, status: :unauthorized
    end
  end

  def show
    user = @current_user
    if user
      render json: { 
        user: {
          id: user.id,
          username: user.username,
          email: user.email,
          profile_image_url: user.profile_image_url
        }
      }, status: :ok
    else
      render json: { status: 'error', message: 'ユーザーが見つかりません' }, status: :unauthorized
    end
  end

  def update
    user = User.find_by(id: @current_user.id)

    if user.update(user_params)
      @current_user.update(user_params)
      render json: { status: 'success', message: 'ユーザー情報を更新しました' }, status: :ok
    else
      render json: { status: 'error', message: 'ユーザー情報の更新に失敗しました' }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find_by(id: @current_user.id)
    if user.destroy
      render json: { status: 'success', message: 'ユーザーを削除しました' }, status: :ok
    else
      render json: { status: 'error', message: 'ユーザーの削除に失敗しました' }, status: :unprocessable_entity
    end
  end
  
  
  
  private
  
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
  
  def jwt_create_token(user)
    payload = { user_id: user.id }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end

