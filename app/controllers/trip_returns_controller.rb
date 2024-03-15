class TripReturnsController < ApplicationController
  before_action :jwt_authenticate

  def update
    trip = @current_user.trips.find_by(id: params[:trip_id])

    if trip.nil? || trip.user != @current_user
      render json: { status: 'error', message: '操作が許可されていません' }, status: :forbidden
      return
    end

    if trip.departure_time > Time.zone.now
      render json: { status: 'error', message: '出航していないトリップは帰投報告できません' }, status: :unprocessable_entity
      return
    end

    # Trip の trip_return_time と return_details を更新
    if trip.update(return_time: Time.zone.now, return_details: trip_return_params[:return_details])
      render json: { status: 'success', message: '帰投報告が登録されました', data: trip }, status: :ok
    else
      render json: { status: 'error', message: '帰投報告の更新に失敗しました' }, status: :unprocessable_entity
    end
  end
  
  private

  def trip_return_params
    params.require(:trip).permit(:return_details)
  end
end

