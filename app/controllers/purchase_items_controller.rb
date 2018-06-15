class PurchaseItemsController < ApplicationController
	require 'line/bot'

  protect_from_forgery except: [:add, :list, :agent, :callback]

  def agent
    if params[:queryResult]!=nil then
      if params[:queryResult][:action]=="add_item" then
				add(params[:queryResult][:parameters][:goods])
		  elsif params[:queryResult][:action]=="show_list" then
				list()
			elsif params[:queryResult][:action]=="bought" then
				bought(params[:queryResult][:parameters][:goods])
			end
		end
	end	

  def list
    @items = Item.where(done:false)
		if @items.length == 0 then
			speech_str = "買い物リストは空だよ"
		else	
			speech_str = @items.map{|item| item.name}.join('と、')+"を買ってきてね"
    end

		msg = {
			fulfillmentText: speech_str
		}

		respond_to do |format|
			format.html
			format.json { render json: msg }
		end	
  end

  def add(goods)
    new_item = Item.new(name:goods)
    new_item.save
    speech_str = "#{goods}を追加したよ"

    msg = {
      fulfillmentText: speech_str
    }

    respond_to do |format|
      format.json  { render json: msg }
    end
  end

  def bought(goods)
		Item.where(name: goods).map { |item|
			item.done = true
			item.save
		}	
    speech_str = "#{goods}買ってきてくれて、ありがとう"

		respond_to do |format|
			format.json { render json: {fulfillmentText: speech_str}}
		end

	end

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
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)

    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    }

    head :ok
	end

end
