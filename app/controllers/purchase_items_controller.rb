class PurchaseItemsController < ApplicationController

  protect_from_forgery except: [:add, :list, :agent]

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
			speech_str = @items.map{|item| item.name}.join('と')+"を買ってきてね"
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
	end

end
