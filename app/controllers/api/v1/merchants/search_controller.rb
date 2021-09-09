class Api::V1::Merchants::SearchController < ApplicationController

  def show
    return (render status: :bad_request) if (params[:name] == nil) || (params[:name].empty?)
    merchant_json = MerchantSerializer.new(Merchant.find_one(params[:name]))
    (merchant_json.to_json.include?("null")) ? (render json: { data:{}}) : (render json: merchant_json)
  end
end
