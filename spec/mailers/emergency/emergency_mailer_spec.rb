require "rails_helper"
require "sidekiq/testing"

RSpec.describe EmergencyMailer, type: :mailer do
  # メール配列をテスト後にクリア
  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  let(:user) { create(:user) }  # FactoryBotでユーザーを作成
  let(:emergency_contact) { create(:emergency_contact, user: user) }  # 緊急連絡先を作成
  let(:trip) { create(:trip, user: user) }  # トリップを作成

  describe '#emergency_email' do
    before do
      EmergencyMailer.emergency_email(user, emergency_contact, trip.location).deliver_now
    end

    it '緊急連絡先にメールを送信' do
      expect(ActionMailer::Base.deliveries.size).to eq(1)

      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include(emergency_contact.email)
      expect(mail.subject).to eq('緊急メール')
      # メール本文の内容を確認するテストもここに追加可能
    end
  end
end


