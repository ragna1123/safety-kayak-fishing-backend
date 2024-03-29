# frozen_string_literal: true

class EmergencyMailWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'mailers'

  def perform(trip_id)
    trip = Trip.find_by(id: trip_id)
    return unless trip && trip.estimated_return_time < Time.now

    # トリップの帰投時間が過ぎている場合、緊急メールを送信
    send_emergency_mail(trip) if trip.user&.emergency_contacts&.any?
    # send_emergency_line_message(trip) if trip.user && trip.user.emergency_contacts.any? { |contact| contact.line_id.present? }
  end

  private

  # 緊急メールを送信するメソッド
  def send_emergency_mail(trip)
    Rails.logger.info("#{trip.user.username}さんへ、緊急メールを送信しました。帰投報告をしてください")
    trip.user.emergency_contacts.each do |contact|
      EmergencyMailer.emergency_email(trip.user, contact, trip.location).deliver_later
    end
  end

  # 第三者へのLINEメッセージはLINE_IDが取得困難なため、実装を見送り
  # def send_emergency_line_message(trip)
  #   trip.user.emergency_contacts.each do |contact|
  #     if contact.line_id.present?
  #       message = "緊急メッセージ: #{trip.user.username}さんが帰投時刻を過ぎても帰投報告がされていません。現在地: https://www.google.com/maps/?q=#{trip.location.latitude},#{trip.location.longitude}"
  #       LineSendMessageService.new(contact, message).call
  #     end
  #   end
  # end
end
