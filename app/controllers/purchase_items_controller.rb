class PurchaseItemsController < ApplicationController
  def list
  end

  def add
    if params[:queryResult]!=nil then
      goods = params[:queryResult][:parameters][:goods]
    else
      goods = "おむつ"
    end
    speech_str = "#{goods}を追加しました"
    msg = {
      :speech => speech_str,
      :displayText => speech_str,
      :data => {
        :google => {
          :expectUserResponse => false,
          :isSsml => false,
        }
      },
      :source => "(-_-)",
    }

    respond_to do |format|
      format.json  { render json: msg }
    end
  end
end
