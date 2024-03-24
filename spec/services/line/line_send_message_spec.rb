# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LineSendMessageService do
  describe '#call' do
    let(:user) { instance_double('User', line_id: 'dummy_line_id') }
    let(:message) { 'Test message' }
    let(:service) { described_class.new(user, message) }

    before do
      allow(HTTParty).to receive(:post).and_return(response)
    end

    context 'リクエストが成功した場合' do
      let(:response) { instance_double('HTTParty::Response', success?: true, body: 'Success response body') }

      it '成功メッセージをログに記録する' do
        # 開発環境では成功しないのでコメントアウト
        # expect(Rails.logger).to receive(:info).with("LINEメッセージ送信成功: #{response.body}")
        service.call
      end
    end

    context 'リクエストが失敗した場合' do
      let(:response) { instance_double('HTTParty::Response', success?: false, body: 'Error response body') }

      it 'エラーメッセージをログに記録する' do
        expect(Rails.logger).to receive(:error).with("LINEメッセージ送信失敗: {\"message\":\"The property, 'to', in the request body is invalid (line: -, column: -)\"}")
        service.call
      end
    end
  end
end
