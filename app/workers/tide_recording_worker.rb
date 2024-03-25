class TideRecordingWorker
  include Sidekiq::Worker

  TIME_ZONE = 'Tokyo'

  def perform(trip_id)
    trip = Trip.find_by(id: trip_id)
    return unless trip

    location = trip.location

    start_time = trip.departure_time.in_time_zone(TIME_ZONE).beginning_of_day.utc

    end_time = (trip.departure_time.in_time_zone(TIME_ZONE) + 1.day).beginning_of_day.utc - 1.minute

    tide_service = StormGlassIoTideService.new
    response = tide_service.fetch_tide_data(location.latitude, location.longitude, start_time, end_time)

    tide_data = response["data"]

    tide_data.each do |data|
      puts data.inspect

      tide = TideData.create!(
        location: location,
        time: data['time'],
        tide_type: data['type'],
        height: data['height']
      )

      TripTide.create!(
        trip_id: trip.id,
        tide_data_id: tide.id
      )
    end
  end
end
