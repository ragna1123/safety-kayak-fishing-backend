# frozen_string_literal: true

class DepartureTimeAlertWorker
  include Sidekiq::Worker

  def perform(trip_id)
    trip = Trip.find_by(id: trip_id)

    # 潮位データを取得
    TideFetchService.new(trip).call

    # 潮位データをメッセージにして送信
    tide_message = format_tide_data(trip.tide_data)

    # 出船アラートメッセージの組み立て
    message = "出船時間になります。\n出船予定時刻: #{jtc_time(trip.departure_time)}\n帰投予定時間: #{jtc_time(trip.estimated_return_time)}\n#{tide_message}"
    LineSendMessageService.new(trip.user.line_id, message).call

    Rails.logger.info "出船アラートを送信しました: #{message}"
  end

  private

  def format_tide_data(tide_data)
    unique_tide_data = tide_data.uniq { |tide| [tide.time, tide.tide_type, tide.height] }
    # 潮位データからメッセージ用の文字列を生成
    unique_tide_data.map do |tide|
      "時間: #{jtc_time(tide.time)}, 潮位タイプ: #{tide.tide_type}, 高さ: #{tide.height.round(2)}m"
    end.join("\n")
  end

  def jtc_time(time)
    time.in_time_zone('Tokyo').strftime('%H:%M')
  end
end
