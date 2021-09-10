class Api::V1::ItemsController < ApplicationController

  def index
    per_page = params.fetch(:per_page, 20).to_i
    page = params.fetch(:page, 0).to_i
    page = page - 1 unless page == 0
    render json: ItemSerializer.new(Item.offset(page * per_page).limit(per_page))
  end
end
