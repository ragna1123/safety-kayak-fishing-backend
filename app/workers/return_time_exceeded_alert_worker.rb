# frozen_string_literal: true

class ReturnTimeExceededAlertWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'mailers'

  def perform(trip_id)
    trip = Trip.find_by(id: trip_id)
    return unless trip && trip.estimated_return_time < Time.now

    # トリップの帰投時間が過ぎている場合、緊急メールを送信
    send_return_alert_mail(trip) if trip.user && trip.user.line_id.nil?
    send_return_alert_line_message(trip) if trip.user&.line_id.present?
  end

  private

  # 帰投勧告メールを送信するメソッド
  def send_return_alert_mail(trip)
    Rails.logger.info("#{trip.user.username}さんへ、帰投勧告メールを送信しました。帰投報告をしてください")
    ReturnAlertMailer.return_alert_email(trip.user, trip).deliver_later
  end

  # LINEメッセージを送信するメソッド
  def send_return_alert_line_message(trip)
    Rails.logger.info("#{trip.user.username}さんへ、帰投勧告LINEメッセージを送信しました。帰投報告をしてください")
    return unless trip.user.line_id.present?

    jts_time = convert_jts_time(Time.now)
    jts_return_time = convert_jts_time(trip.estimated_return_time)
    message = "#{trip.user.username}さんが帰投時刻を過ぎても帰投報告がされていません。帰投予定時刻: #{jts_return_time}、現在時刻: #{jts_time}"
    LineSendMessageService.new(trip.user, message).call
  end

  def convert_jts_time(time)
    jts_time = time + 9.hours
    jts_time.strftime('%Y/%m/%d %H:%M')
  end
end
