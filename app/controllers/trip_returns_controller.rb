# frozen_string_literal: true

class TripReturnsController < ApplicationController
  before_action :jwt_authenticate

  def returned
    trip = @current_user.trips.returned_trips.order(return_time: :desc)

    if trip.present?
      render json: { status: 'success', data: trip }, status: :ok
    else
      render json: { status: 'success', message: '帰投報告はありません' }, status: :ok
    end
  end

  def unreturned
    trip = @current_user.trips.unreturned_trips.order(return_time: :desc)

    if trip.present?
      render json: { status: 'success', data: trip }, status: :ok
    else
      render json: { status: 'success', message: '未帰投報告はありません' }, status: :ok
    end
  end


  def update
    trip = @current_user.trips.find_by(id: params[:id])

    if trip.nil?
      render json: { status: 'error', message: 'トリップが見つかりません' }, status: :not_found
      return
    end
    
    unless active?(trip)
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

  def active?(trip)
    Time.zone.now > trip.departure_time
  end
end
