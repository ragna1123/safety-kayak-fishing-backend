# frozen_string_literal: true

class TripsController < ApplicationController
  before_action :jwt_authenticate

  def create
    trip = @current_user.trips.new(trip_params.except(:location_data))
  
    location = Location.find_or_create_by(latitude: trip_params[:location_data][:latitude], longitude: trip_params[:location_data][:longitude])
    trip.location_id = location.id

    # 日の出・日の入りの時間を取得


    
  
    if trip.save
      render json: { status: 'success', message: '出船予定が登録されました' }, status: :created
    else
      render json: { status: 'error', message: 'リクエストの値が無効です'}, status: :unprocessable_entity
    end
  end
  

  private

  def trip_params
    params.require(:trip).permit(:departure_time, :estimated_return_time, :details, location_data: [:latitude, :longitude])
  end
  
end
