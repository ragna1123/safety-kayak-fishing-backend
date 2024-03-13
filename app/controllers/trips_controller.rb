# frozen_string_literal: true

class TripsController < ApplicationController
  before_action :jwt_authenticate

  def create
    trip = @current_user.trips.build(trip_params)
    if trip.save
      render json: { status: 'success', message: '出船予定が登録されました' }, status: :created
    else
      render json: { status: 'error', message: 'リクエストの値が無効です'}, status: :unprocessable_entity
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:location_data, :departure_time, :estimated_return_time, :details)
  end
end
