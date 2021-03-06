class Api::V1::MerchantsController < ApplicationController

  def index
    pagination
    render json: MerchantSerializer.new(Merchant.offset(@page * @per_page).limit(@per_page))
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  private
  def pagination
    @per_page = params.fetch(:per_page, 20).to_i
    @page = params.fetch(:page, 0).to_i
    @page = @page - 1 unless @page == 0
  end
end
