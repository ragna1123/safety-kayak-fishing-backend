# frozen_string_literal: true

class TripsController < ApplicationController
  before_action :jwt_authenticate
  before_action :set_trip, only: %i[show update destroy]
  before_action :authorize_user, only: %i[show update destroy]
  before_action :validate_location_and_time, only: %i[create]

  # 出船予定を作成する POST /api/trips
  def create
    trip = @current_user.trips.new(trip_params.except(:location_data))
  
    set_location_and_fetch_data(trip)
  
    if trip.save
      schedule_set_jobs(trip)
      render json: { status: 'success', message: '出船予定が登録されました', data: trip }, status: :created
    else
      render_error(trip.errors.full_messages.to_sentence)
    end
  rescue StandardError => e
    log_and_render_transaction_error(e)
  end

  # 出船予定一覧を取得する GET /api/trips
  def index
    trips = @current_user.trips.future_trips.order(departure_time: :desc)
    trips_data = trips.map do |trip|
      {
        trip: trip,
        location_data: trip.location
      }
    end
    render json: { status: 'success', data: trips_data }, status: :ok
  end

  # 出船予定を取得する GET /api/trips/:id
  def show
    render json: { status: 'success', data: {trip:@trip, location_data: @trip.location }}, status: :ok
  end

  # 出船中の予定を取得する GET /api/trips/active
  def active
    active_trip = @current_user.trips.active_trips.first
    if active_trip.present? && !active_trip.return_time.present?
      render json: { status: 'success', data: {trip:active_trip, location_data: active_trip.location }}, status: :ok
    else
      render json: { status: 'success', message: '出船中の予定はありません', data: {}, date: Time.zone.now }, status: :ok
    end
  end

  # 出船予定を更新する PUT /api/trips/:id
  def update
    @trip.assign_attributes(trip_params.except(:location_data))
      if @trip.save
        clear_scheduled_job(@trip)
        schedule_set_jobs(@trip)
        render json: { status: 'success', message: '出船予定が更新されました', data: @trip }, status: :ok
      else
        render_error('リクエストの値が無効です')
      end
  rescue StandardError => e
    log_and_render_transaction_error(e)
  end

  # 出船予定を削除する DELETE /api/trips/:id
  def destroy
    ActiveRecord::Base.transaction do
      if @trip.destroy
        # 既存のSidekiqジョブをキャンセルする
        clear_scheduled_job(@trip)
        render json: { status: 'success', message: '出船予定が削除されました' }, status: :ok
      else
        render json: { status: 'error', message: '出船予定の削除に失敗しました' }, status: :unprocessable_entity
      end
    end
  end

    
  private

  # --------------------------------------------------
  # 出船予定の取得と権限のチェック

  # 出船予定を取得するメソッド
  def set_trip
    @trip = Trip.find_by(id: params[:id])
    render_not_found('出船予定が見つかりません') unless @trip
  end

  # 出船予定のユーザーがログインユーザーと一致するかをチェックするメソッド
  def authorize_user
    render_forbidden('他人の出船予定は操作できません') unless @trip.user_id == @current_user.id
  end

  # --------------------------------------------------
  # 出船予定の位置情報と出船予定日のバリデーション

  # 位置情報と出船予定日が有効かどうかをチェックするメソッド
  def validate_location_and_time
    # createアクションの場合のみ位置情報をチェックする
    location_validates(trip_params[:location_data]) if action_name == 'create'
    time_validates(trip_params[:departure_time], trip_params[:estimated_return_time])
    validate_departure_time(trip_params[:departure_time], trip_params[:estimated_return_time])
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

  # 出船時間が被っていないかをチェックするメソッド
  def validate_departure_time(departure_time, estimated_return_time)
    @current_user.trips.future_trips.each do |t|
      next unless departure_time < t.estimated_return_time && estimated_return_time > t.departure_time
  
      Rails.logger.info "重複検出: 出船予定ID #{t.id} と時間が重複しています。"
      Rails.logger.info "重複予定の詳細: [重複予定ID #{t.id}] 出発時間: #{t.departure_time}, 帰還予定時間: #{t.estimated_return_time}"
      render json: { status: 'error', message: '出船時間が被っています' }, status: :unprocessable_entity
      return false # メソッドから抜ける
    end
    true
  end

  # --------------------------------------------------
  # 出船予定の位置情報と日の出と日没のデータを設定するメソッド

  # 位置情報を設定し、日の出と日没のデータを取得するメソッド
  def set_location_and_fetch_data(trip)
    set_location(trip)
    fetch_sunrise_sunset_data(trip)
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
  
      if response[:error].present?
        Rails.logger.error("Sunrise Sunset API error: #{response[:error]}")
      else
        trip.sunrise_time = response[:sunrise]
        trip.sunset_time = response[:sunset]
      end
    else
      Rails.logger.error("トリップID #{trip.id} の出発時間がありません")
    end
  end

  # --------------------------------------------------
  # Sidekiqのジョブ

  # sidekiqのジョブをスケジュールを一括設定するメソッド
  def schedule_set_jobs(trip)
    departure_alert_set(trip)
    limit_time_alert_set(trip)
    schedule_future_weather_recording(trip)
  end

  def departure_alert_set(trip)
    # 15分前に出船アラートを送信
    alert_time = trip.departure_time - 15.minutes
    # 出船時間になったらアラートを送信
    DepartureTimeAlertWorker.perform_at(alert_time, trip.id)
  end

  # Sidekiqのジョブをスケジュールするメソッド
  def limit_time_alert_set(trip)
    # 予定の帰還時間になったらアラートを送信
    ReturnTimeExceededAlertWorker.perform_at(trip.estimated_return_time, trip.id)
    # 15分後に緊急メールを送信
    delay_time = 15.minutes
    limit_time = trip.estimated_return_time + delay_time
    EmergencyMailWorker.perform_at(limit_time, trip.id)
  end

  # 天気データの取得スケジュール
  def schedule_future_weather_recording(trip)
    # 当日に二時間おきに天気データを取得をスケジュール
    future_intervals(trip).each do |time|
      Rails.logger.info "トリップ #{trip.id} に対して #{time} で WeatherRecordingWorker をスケジュール中"
      WeatherRecordingWorker.perform_at(time, trip.id)
    end
  rescue StandardError => e
    Rails.logger.error "トリップ #{id} の未来の天気データスケジューリングに失敗しました: #{e.message}"
  end

  # 現在時刻から estimated_return__time の間を2時間ごとに分割
  def future_intervals(trip)
    intervals = []
    # 日本時間の0時をUTCに変換（前日の15時）
    start_time = trip.departure_time.in_time_zone('Tokyo').beginning_of_day.utc
    # 日本時間の翌日0時（24時）をUTCに変換し、1分引く（当日の15時59分）
    end_time = (trip.departure_time.in_time_zone('Tokyo') + 1.day).beginning_of_day.utc - 1.minute

    time = start_time
    while time <= end_time
      intervals << time
      time += 2.hours
    end
    intervals
  end

  # スケジュールされたジョブをキャンセルするメソッド
  def clear_scheduled_job(trip)
    Sidekiq::ScheduledSet.new.select { |job| job.args[0] == trip.id }.each(&:delete)
  end

  # --------------------------------------------------
  # ログとエラーハンドリング

  # トランザクションエラーをログに記録し、エラーレスポンスをレンダリングするメソッド
  def log_and_render_transaction_error(exception)
    Rails.logger.error("Transaction error: #{exception}")
    render json: { status: 'error', message: 'トランザクション中にエラーが発生しました。' }, status: :internal_server_error
  end

  def render_error(message)
    render json: { status: 'error', message: }, status: :unprocessable_entity
  end

  def render_not_found(message)
    render json: { status: 'error', message: }, status: :not_found
  end

  def render_forbidden(message)
    render json: { status: 'error', message: }, status: :forbidden
  end

  # --------------------------------------------------
  # パラメータの許可

  def trip_params
    params.require(:trip).permit(:departure_time, :estimated_return_time, :details,
                                 location_data: %i[latitude longitude])
  end
end
