class LineBotsController < ApplicationController
  require "line/bot"
  skip_before_action :verify_authenticity_token

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request and return
    end

    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = event.message['text']
          #user = User.find_by(uid: user_id)
          text =
            case message
            when /問題/
              "問題を選んでください"
            end
          reply_message = {
            type: 'text',
            text: text
          }
          case reply_message[:text]
          when "問題を選んでください"
            add_text = "問題一覧"
          end
          reply_message_add = {
            type: "text",
            text: add_text
          }

          client.reply_message(event['replyToken'], [reply_message,reply_message_add])
        end
      end
    end

    render json: { status: :ok}
  end
end