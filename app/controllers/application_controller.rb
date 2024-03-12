class ApplicationController < ActionController::API
  before_action :jwt_authenticate

  private

  def jwt_authenticate
    auth_header = request.headers['Authorization']
    if auth_header.present? && auth_header.split(' ').size == 2
      scheme, token = auth_header.split(' ')
      if scheme.downcase == 'bearer'
        begin
          decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base)
          user_id = decoded_token[0]['user_id']
          @current_user = User.find_by(id: user_id)
        rescue JWT::DecodeError, JWT::VerificationError, JWT::InvalidSubError
          @current_user = nil
        end
      end
    end
    @current_user ||= nil

    # 認証失敗時の処理
    render_unauthorized if @current_user.nil?
  end

  def render_unauthorized
    render json: { status: 'error', message: 'トークンが無効です' }, status: :unauthorized
  end
end


