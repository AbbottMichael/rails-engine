class Api::V1::Revenue::SearchMerchantController < ApplicationController

  def index
    return (quantity_error) if (params[:quantity] == nil) || (params[:quantity].to_i <= 0)
    render json: MerchantNameRevenueSerializer.new(Merchant.total_revenue_desc(params[:quantity].to_i))
  end

  def show
    return (id_error) if (params[:id] == nil) || (params[:id].to_i <= 0)
    merchant_json = MerchantRevenueSerializer.new(Merchant.total_revenue_by_id(params[:id]))
    (merchant_json.to_json.include?("null")) ? (render json: { data:{}}, status: :not_found) : (render json: merchant_json)
  end

  private
  def quantity_error
    render json: { error: "must provide a valid quantity" }, status: :bad_request
  end
  
  def id_error
    render json: { error: "must provide a valid id" }, status: :bad_request
  end
end
