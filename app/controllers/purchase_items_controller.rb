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
      elsif params[:queryResult][:action]=="send_list" then
        callback()
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
    speech_str = "#{goods}を買ってきてくれて、ありがとう"

		respond_to do |format|
			format.json { render json: {fulfillmentText: speech_str}}
		end

	end

  def del_item(id)
    Item.find(id).destroy
  end

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    @items = Item.where(done: false)
    if @items.length > 0 then
      message = "[買い物リスト] "+@items.map{|item| item.name}.join(", ")

      user_id = 'C05a7b2b6d2bd4891101d8638bb8f8f91'
      message = {
        type: 'text',
        text: message
      }
      response = client.push_message(user_id, message)
      head :ok
      speech_str = "LINEに買い物リスト送りました"
    else
      speech_str = "買うものがなかったので送ってないです"
    end
    
    respond_to do |format|
      format.json { render json: {fulfillmentText: speech_str}}
    end
  end
end
