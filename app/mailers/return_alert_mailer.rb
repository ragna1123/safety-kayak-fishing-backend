# frozen_string_literal: true

class ReturnAlertMailer < ApplicationMailer
  default from: 'noreply@example.com'

  # 緊急メールを送信する
  def return_alert_email(user, trip)
    # ユーザーと連絡先が有効かチェック
    return if user.nil?

    @user = user
    @return_time = convert_jts_time(trip.estimated_return_time)

    # メールを送信
    mail(to: @user.email, subject: '緊急メール')
  end

  private

  def convert_jts_time(time)
    jts_time = time + 9.hours
    jts_time.strftime('%Y/%m/%d %H:%M')
  end
end
