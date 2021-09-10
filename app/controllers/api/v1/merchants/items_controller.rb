class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    # per_page = params.fetch(:per_page, 20).to_i
    # page = params.fetch(:page, 0).to_i
    # page = page - 1 unless page == 0
    # render json: MerchantSerializer.new(Merchant.offset(page * per_page).limit(per_page))
    render json: ItemSerializer.new(Merchant.find(params[:merchant_id].to_i).items)
  end
end
