class Api::V1::Revenue::SearchItemController < ApplicationController
  def index
    quantity = params.fetch(:quantity, 10).to_i
    return (quantity_error) if (quantity == nil) || (quantity <= 0)
    render json: ItemRevenueSerializer.new(Item.total_revenue_desc(quantity))
  end

  private
  def quantity_error
    render json: { error: "must provide a valid quantity" }, status: :bad_request
  end
end
