class EmergencyMailWorker
  include Sidekiq::Worker

  # トリップの帰投時間が過ぎたら緊急メールを送信する
  def perform(trip_id)
    trip = Trip.find_by(id: trip_id)
    return unless trip && trip.estimated_return_time < Time.now
    puts trip.user.emergency_contacts

    send_emergency_mail(trip) if trip.user && trip.user.emergency_contacts.any?
  end

  private

  def send_emergency_mail(trip)
    Rails.logger.info("#{trip.user.username}さんへ、緊急メールを送信しました。帰投報告をしてください")
    trip.user.emergency_contacts.each do |contact|
      EmergencyMailer.emergency_email(trip.user, contact, trip.location).deliver_later
    end
  end
end


