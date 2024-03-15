# frozen_string_literal: true

class TripsController < ApplicationController
  before_action :jwt_authenticate
  before_action :set_trip, only: [:show, :update, :destroy]
  before_action :authorize_user, only: [:show, :update, :destroy]
  before_action :validate_location_and_time, only: [:create, :update]

  # 出船予定を作成する POST /api/trips
  def create
    trip = @current_user.trips.new(trip_params.except(:location_data))
    set_location_and_fetch_data(trip)

    if trip.save
      render json: { status: 'success', message: '出船予定が登録されました', data: trip }, status: :created
    else
      render_error('リクエストの値が無効です')
    end
  end

  # 出船予定一覧を取得する GET /api/trips
  def index
    trips = @current_user.trips.future_trips.order(departure_time: :desc)
    render json: { status: 'success', data: trips }, status: :ok
  end

  # 出船予定を取得する GET /api/trips/:id
  def show
    render json: { status: 'success', data: @trip }, status: :ok
  end

  # 出船予定を更新する PUT /api/trips/:id
  def update
    if @trip.update(trip_params.except(:location_data))
      render json: { status: 'success', message: '出船予定が更新されました', data: @trip }, status: :ok
    else
      render_error('リクエストの値が無効です')
    end
  end

  # 出船予定を削除する DELETE /api/trips/:id
  def destroy
    @trip.destroy
    render json: { status: 'success', message: '出船予定が削除されました' }, status: :ok
  end

  private

  # 出船予定を取得するメソッド
  def set_trip
    @trip = Trip.find_by(id: params[:id])
    render_not_found('出船予定が見つかりません') unless @trip
  end

  # 出船予定のユーザーがログインユーザーと一致するかをチェックするメソッド
  def authorize_user
    render_forbidden('他人の出船予定は操作できません') unless @trip.user_id == @current_user.id
  end

  # 位置情報と出船予定日が有効かどうかをチェックするメソッド
  def validate_location_and_time
    # createアクションの場合のみ位置情報をチェックする
    location_validates(trip_params[:location_data]) if action_name == 'create'
    time_validates(trip_params[:departure_time], trip_params[:estimated_return_time])
  end

  # 位置情報を設定し、日の出と日没のデータを取得するメソッド
  def set_location_and_fetch_data(trip)
    set_location(trip)
    fetch_sunrise_sunset_data(trip)
  end

  # 緯度と経度が有効な値かどうかをチェックするメソッド
  def location_validates(location_data)
    if location_data.blank? || location_data[:latitude].blank? || location_data[:longitude].blank?
      render json: { status: 'error', message: '位置情報が必要です' }, status: :unprocessable_entity
      return false
    end

    latitude = location_data[:latitude].to_f
    longitude = location_data[:longitude].to_f

    # 緯度が-90から90の間、経度が-180から180の間の値であるかをチェック
    unless latitude.between?(-90, 90) && longitude.between?(-180, 180)
      render json: { status: 'error', message: '位置情報が無効です' }, status: :unprocessable_entity
      return false
    end

    true
  end

  # 出船予定日が過去でないかをチェックするメソッド
  def time_validates(departure_time, estimated_return_time)
    if departure_time.nil? || estimated_return_time.nil?
      render json: { status: 'error', message: '出発時間と帰還予定時間が必要です' }, status: :unprocessable_entity
      return false
    end

    if departure_time > Time.zone.now && estimated_return_time > departure_time
      true
    else
      render json: { status: 'error', message: '出船予定日が無効です' }, status: :unprocessable_entity
      false
    end
  end

  # 出船予定に位置情報を設定するメソッド
  def set_location(trip)
    location_data = trip_params[:location_data]
    location = Location.find_or_create_by(latitude: location_data[:latitude], longitude: location_data[:longitude])
    trip.location = location
  end

  # 出船予定の日の出と日没のデータを取得するメソッド
  def fetch_sunrise_sunset_data(trip)
    if trip.departure_time.present?
      date = trip.departure_time.to_date
      response = SunriseSunsetService.new(date, trip.location).call
      if response[:error]
        Rails.logger.error("Sunrise Sunset API error: #{response[:error]}")
      else
        trip.sunrise_time = response[:sunrise]
        trip.sunset_time = response[:sunset]
      end
    else
      Rails.logger.error("Departure time is nil for trip with id #{trip.id}")
    end
  end


  def render_error(message)
    render json: { status: 'error', message: message }, status: :unprocessable_entity
  end

  def render_not_found(message)
    render json: { status: 'error', message: message }, status: :not_found
  end

  def render_forbidden(message)
    render json: { status: 'error', message: message }, status: :forbidden
  end

  def trip_params
    params.require(:trip).permit(:departure_time, :estimated_return_time, :details, location_data: %i[latitude longitude])
  end
end

