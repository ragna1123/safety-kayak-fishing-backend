class TideRecordingWorker
  include Sidekiq::Worker

  def perform(location_id)
    location = Location.find(location_id)
    
    # StormglassIdTideService などを使って潮位データを取得
    tide_service = StormglassIdTideService.new(ENV['STORM_GLASS_API_KEY'])
    tide_data = tide_service.fetch_tide_data(location.latitude, location.longitude, Time.now, Time.now + 1.hour)

    # 取得した潮位データをデータベースに保存
    Tide.create!(
      location: location,
      recorded_at: Time.now,
      tide_level: tide_data['level'],
      # 他の必要なフィールドがあればここに追加
    )
  end
end
