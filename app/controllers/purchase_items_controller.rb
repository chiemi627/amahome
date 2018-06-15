class PurchaseItemsController < ApplicationController

  protect_from_forgery except: :add

  def list
    @items = Item.all
		if @item.length == 0 then
			speech_str = "買い物リストは空だよ"
		else	
      speech_str = @items.join('と')+"を買ってきてね"
    end

		msg = {
			fulfillmentText: speech_str
		}

		respond_to do |format|
			format.json { render json: msg }
		end	
  end

  def add
    if params[:queryResult]!=nil then
      goods = params[:queryResult][:parameters][:goods]
    else
      goods = "おむつ"
    end
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
end
