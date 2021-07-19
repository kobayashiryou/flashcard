class LineBotsController < ApplicationController
  require "line/bot"
  skip_before_action :verify_authenticity_token

  def client
    @client ||= Line::Bot::Client.new {|config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env["HTTP_X_LINE_SIGNATURE"]
    unless client.validate_signature(body, signature)
      head :bad_request and return
    end

    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          user_id = event["source"]["userId"]
          user = User.find_by(uid: user_id) || User.create(uid: user_id)
          message = event.message["text"]
          text =
            case message
            when "説明"
              "このアプリでは全角を使用してください。\n以下の「」内の文字を入力して操作してください。\n※「」の入力は必要ありません。
              \n・「問題を作る」\n問題の作り方について説明が表示されます。\n・「問題」\n問題一覧が表示されます。一覧から問題を選ぶこともできます。\n・「答え」\n答え一覧が表示されます。\n・「削除」\n問題の削除ができます。"
            when "問題"
              "問題を選んでください。\n問題？と入力してください。\n？の部分に該当する数字を入れてください。"
            when "答え"
              "答え一覧です"
            when "問題を作る"
              "問題＝？の形で入力してください。\n？の部分に問題文を入れてください"
            when "削除"
              "削除する問題を選んでください。\n削除？と入力してください。\n？の部分に数字を入れてください。"
            when /問題+\d/
              index = message.gsub(/問題*/, "").strip.to_i
              questions = user.questions.to_a
              question = questions.find.with_index(1) {|_question, _index| index == _index }
              "#{question.body}\n答えを見るときは、答え#{index}と入力してください"
            when /答え+\d/
              index = message.gsub(/答え*/, "").strip.to_i
              questions = user.questions.to_a
              question = questions.find.with_index(1) {|_question, _index| index == _index }
              question.answer.to_s
            when /削除+\d/
              index = message.gsub(/削除*/, "").strip.to_i
              questions = user.questions.to_a
              question = questions.find.with_index(1) {|_question, _index| index == _index }
              question.destroy!
              "問題#{index}の削除が完了しました。"
            when message
              if message.scan(/問題＝/) == ["問題＝"]
                body = message.gsub(/問題＝*/, "").strip
                if body == ""
                  "登録ができませんでした。\n「問題＝」の後に問題文を入れてください"
                else
                  question = user.questions.create!(body: body)
                  index = user.questions.count(:id)
                  "#{index} : 問題「#{question.body}」の登録が完了しました。\n続いて答えを登録してください。\n#{index}の答え＝？の形で入力してください"
                end
              elsif message.scan(/答え＝/) == ["答え＝"]
                answer = message.gsub(/\d+の答え＝*/, "").strip
                index = message.gsub(/の答え＝#{answer}/, "").strip.to_i
                questions = user.questions.to_a
                question = questions.find.with_index(1) {|_question, _index| index == _index }
                question.update!(answer: answer)
                "#{index} : 答え「#{answer}」の登録が完了しました。"
              end
            end

          reply_message = {
            type: "text",
            text: text,
          }
          client.reply_message(event["replyToken"], reply_message)
          if reply_message[:text] == "問題を選んでください。\n問題？と入力してください。\n？の部分に該当する数字を入れてください。"
            questions = user.questions
            add_text = questions.map.with_index(1) {|question, index| "#{index}：#{question.body}" }.join("\n")
            message = {
              type: "text",
              text: add_text,
            }
            response = client.push_message(user_id.to_s, message)
            p response
          elsif reply_message[:text] == "答え一覧です"
            questions = user.questions
            add_text = questions.map.with_index(1) {|question, index| "#{index}：#{question.answer}" }.join("\n")
            message = {
              type: "text",
              text: add_text,
            }
            response = client.push_message(user_id.to_s, message)
            p response
          elsif reply_message[:text] == "削除する問題を選んでください。\n削除？と入力してください。\n？の部分に数字を入れてください。"
            questions = user.questions
            add_text = questions.map.with_index(1) {|question, index| "#{index}：#{question.body}" }.join("\n")
            message = {
              type: "text",
              text: add_text,
            }
            response = client.push_message(user_id.to_s, message)
            p response
          end
        end
      end
    end

    render json: { status: :ok }
  end
end
