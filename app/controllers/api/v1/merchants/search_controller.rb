class Api::V1::Merchants::SearchController < ApplicationController

  def index
    return (quantity_error) if (params[:quantity].to_i == nil) || (params[:quantity].to_i <= 0)
    render json: ItemsSoldSerializer.new(Merchant.total_items_sold_desc(params[:quantity].to_i))
  end

  def show
    return (render status: :bad_request) if (params[:name] == nil) || (params[:name].empty?)
    merchant_json = MerchantSerializer.new(Merchant.find_one(params[:name]))
    (merchant_json.to_json.include?("null")) ? (render json: { data:{}}) : (render json: merchant_json)
  end

  private
  def quantity_error
    render json: { error: "must provide a valid quantity" }, status: :bad_request
  end
end
