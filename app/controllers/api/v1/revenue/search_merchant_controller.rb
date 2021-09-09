class Api::V1::Revenue::SearchMerchantController < ApplicationController
  def index
    return (quantity_error) if (params[:quantity] == nil) || (params[:quantity].to_i <= 0)
    render json: MerchantNameRevenueSerializer.new(Merchant.total_revenue_desc(params[:quantity].to_i))
  end

  private
  def quantity_error
    render json: { error: "must provide a valid quantity" }, status: :bad_request
  end
end
