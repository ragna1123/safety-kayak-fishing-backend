# frozen_string_literal: true

class ReturnTimeExceededAlertWorker
  include Sidekiq::Worker

  def perform(trip_id)
    trip = Trip.find_by(id: trip_id)
    # トリップの帰投時間が過ぎているかをチェック
    return unless trip.estimated_return_time < Time.now

    # トリップの帰投時間が過ぎている場合、緊急メールを送信
    return_instraction(trip)
  end

  private

  def return_instraction(trip)
    Rails.logger.info("#{trip.user.username}さん。帰投報告をしてください")
    # 通知を送信する処理
  end
end
