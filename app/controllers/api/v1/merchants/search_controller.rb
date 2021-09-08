class Api::V1::Merchants::SearchController < ApplicationController

  def show
    return (render status: :bad_request) if (params[:name] == nil) || (params[:name].empty?)
    render json: MerchantSerializer.new(Merchant.find_one(params[:name]))
  end
end
