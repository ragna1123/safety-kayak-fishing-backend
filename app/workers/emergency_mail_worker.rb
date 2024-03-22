# frozen_string_literal: true

class EmergencyMailWorker
  include Sidekiq::Worker

  def perform(trip_id)
    trip = Trip.find_by(id: trip_id)
    # トリップの帰投時間が過ぎているかをチェック
    return unless trip.estimated_return_time < Time.now

    # トリップの帰投時間が過ぎている場合、緊急メールを送信
    send_emegency_mail(trip)
  end

  private

  def send_emegency_mail(trip)
    Rails.logger.info("#{trip.user.username}さん。緊急メールを送信しました。帰投報告をしてください")
    # 緊急連絡先への通知
    
  end
end
