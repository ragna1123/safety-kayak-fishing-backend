class ReturnAlertMailer < ApplicationMailer
  default from: 'noreply@example.com'

  # 緊急メールを送信する
  def return_alert_email(user)
    # ユーザーと連絡先が有効かチェック
    return if user.nil?

    @user = user

    # メールを送信
    mail(to: @user.email, subject: '緊急メール')
  end
end
