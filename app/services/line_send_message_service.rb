class LineSendMessageService
  include HTTParty
  base_uri 'https://api.line.me'

  LINE_API_URL = '/v2/bot/message/push'.freeze
  HEADERS = {
    "Content-Type" => "application/json",
    "Authorization" => "Bearer #{ENV['LINE_MESSAGE_API_KEY']}"
  }.freeze

  def initialize(user, message)
    @message = message
    @user = user
  end

  def call
    response = self.class.post(LINE_API_URL, body: request_body, headers: HEADERS)
    log_response(response)
    response.success? # 返り値として成功かどうかを返す
  end

  private

  def request_body
    {
      to: @user.line_id,
      messages: [{ type: 'text', text: @message }]
    }.to_json
  end

  def log_response(response)
    if response.success?
      Rails.logger.info("LINEメッセージ送信成功: #{response.body}")
    else
      Rails.logger.error("LINEメッセージ送信失敗: #{response.body}")
    end
  end
end
