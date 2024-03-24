# frozen_string_literal: true

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
    # ユーザーが作成したトリップの履歴と天気履歴を取得
    trip = @current_user.trips.past_trips.find_by(id: params[:id])

    # トリップが存在しない場合はエラーレスポンスを返す
    if trip.nil?
      render json: { status: 'error', message: 'トリップが見つかりません' }, status: :not_found
      return
    end

    tide_histories = trip.trip_tides
    weather_histories = trip.trip_weathers
    render json: {
      status: 'success',
      data: trip,
      weather_histories: weather_histories.map(&:weather_data),
      tide_histories: tide_histories.map(&:tide_data)
    }, status: :ok
  end

  private

  def render_error(message)
    render json: { status: 'error', message: }, status: :unprocessable_entity
  end
end
