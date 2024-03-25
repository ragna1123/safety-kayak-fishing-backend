# frozen_string_literal: true

class TideFetchService
  TIME_ZONE = 'Tokyo'

  def initialize(trip)
    @trip = trip
  end

  def call
    return unless @trip

    location = @trip.location

    # departure_timeの0時から23時59分までの潮位データを取得
    start_time = @trip.departure_time.in_time_zone(TIME_ZONE).beginning_of_day.utc

    end_time = (@trip.departure_time.in_time_zone(TIME_ZONE) + 1.day).beginning_of_day.utc - 1.minute

    tide_service = StormGlassIoTideService.new
    response = tide_service.fetch_tide_data(location.latitude, location.longitude, start_time, end_time)

    tide_data = response['data']

    Rails.logger.info("Tide data: #{tide_data}")

    tide_data.each do |data|
      tide = TideData.create!(
        location:,
        time: data['time'],
        tide_type: data['type'],
        height: data['height']
      )

      TripTide.create!(
        trip_id: @trip.id,
        tide_data_id: tide.id
      )
    end
  end
end
