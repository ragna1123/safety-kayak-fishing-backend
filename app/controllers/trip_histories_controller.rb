class TripHistoriesController < ApplicationController
  before_action :jwt_authenticate

  def index
    # ユーザーが作成したトリップの履歴を取得
    trips = @current_user.trips.past_trips.order(departure_time: :desc)

    if trips.present?
      render json: { status: 'success', data: trips }, status: :ok
    else
      render json: { status: 'success', message: '過去の出船予定はありません' }, status: :ok
    end
  end

  def show
    trip = Trip.find(params[:id])
    if trip.user_id == @current_user.id
      render json: { status: 'success', data: trip }, status: :ok
    else
      render json: { status: 'error', message: '他のユーザーの出船予定は閲覧できません' }, status: :forbidden
    end
  end
end
