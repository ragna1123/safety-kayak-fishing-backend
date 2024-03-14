class TripsController < ApplicationController
  before_action :jwt_authenticate

  def create
    trip = @current_user.trips.new(trip_params.except(:location_data))
    return unless location_validates(trip_params[:location_data])

    set_location(trip)
    fetch_sunrise_sunset_data(trip)

    if trip.save
      render json: { status: 'success', message: '出船予定が登録されました' }, status: :created
    else
      render_error('リクエストの値が無効です')
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:departure_time, :estimated_return_time, :details, location_data: [:latitude, :longitude])
  end

  def render_error(message)
    render json: { status: 'error', message: message }, status: :unprocessable_entity
  end

  # 緯度と経度が有効な値かどうかをチェックするメソッド
  def location_validates(location_data)
    if location_data[:latitude].blank? || location_data[:longitude].blank?
      render json: { status: 'error', message: '位置情報が必要です' }, status: :unprocessable_entity
      return false
    elsif !valid_coordinate?(location_data[:latitude], location_data[:longitude])
      render json: { status: 'error', message: '位置情報が無効です' }, status: :unprocessable_entity
      return false
    end
    true
  end

  def valid_coordinate?(latitude, longitude)
    latitude.to_f.between?(-90, 90) && longitude.to_f.between?(-180, 180)
  end

  def set_location(trip)
    location = Location.find_or_create_by(latitude: trip_params[:location_data][:latitude], longitude: trip_params[:location_data][:longitude])
    trip.location = location
  end

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
end

