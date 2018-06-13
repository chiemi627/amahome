class PurchaseItemsController < ApplicationController

  protect_from_forgery except: :add

  def list
    @items = Item.all
  end

  def add
    if params[:queryResult]!=nil then
      goods = params[:queryResult][:parameters][:goods]
    else
      goods = "おむつ"
    end
    new_item = Item.new(name:goods)
    new_item.save
    speech_str = "#{goods}を追加しました"

    msg = {
      fulfillmentText: speech_str
    }

    respond_to do |format|
      format.json  { render json: msg }
    end
  end
end
