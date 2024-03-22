# メーラークラス
class EmergencyMailer < ApplicationMailer
  default from: 'noreply@example.com'

  # 緊急メールを送信する
  def emergency_email(user, contact, location)
    # ユーザーと連絡先が有効かチェック
    return if user.nil? || contact.nil?

    @user = user
    @contact = contact
    @location = location

    # 連絡先に有効なメールアドレスがあるかチェック
    mail(to: @contact.email, subject: '緊急メール') if @contact.email.present?
  end
end

