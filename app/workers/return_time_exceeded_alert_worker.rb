# frozen_string_literal: true

class ReturnTimeExceededAlertWorker
  include Sidekiq::Worker

  def perform(trip_id)
    trip = Trip.find_by(id: trip_id)
    return unless trip && trip.estimated_return_time < Time.now

    # トリップの帰投時間が過ぎている場合、緊急メールを送信
    send_return_alert_line_message(trip)
  end

  private

  def send_emergency_mail(trip)
    Rails.logger.info("#{trip.user.username}さんへ、帰投勧告メールを送信しました。帰投報告をしてください")
    trip.user.emergency_contacts.each do |contact|
      ReturnAlertMailer.return_alert_email(trip.user).deliver_later
    end
  end

  def send_return_alert_line_message(trip)
    if trip.user.line_id.present?
      message = ("#{trip.user.username}さんが帰投時刻を過ぎても帰投報告がされていません。#{Time.now}")
      LineSendMessageService.new(trip.user, message).call
    end
  end
end
