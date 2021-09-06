class Api::V1::MerchantsController < ApplicationController

  def index
    per_page = params.fetch(:per_page, 20).to_i
    page = params.fetch(:page, 0).to_i
    page - 1 if page != 0
    render json: Merchant.offset(page * per_page).limit(per_page)
  end
end
