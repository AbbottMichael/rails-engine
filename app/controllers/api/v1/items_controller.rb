class Api::V1::ItemsController < ApplicationController

  def index
    pagination
    render json: ItemSerializer.new(Item.offset(@page * @per_page).limit(@per_page))
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    new_item = Item.new(item_params)
    if new_item.save
      render status: :created, json: ItemSerializer.new(Item.last)
    else
      render json: { error: "must provide valid data" }, status: :not_acceptable
    end
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render status: :accepted, json: ItemSerializer.new(item)
    elsif Merchant.where(id: params[:merchant_id]) == []
      render json: { error: "merchant does not exist" }, status: :not_found
    else
      render json: { error: "must provide valid data" }, status: :not_acceptable
    end
  end

  private
  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end

  def pagination
    @per_page = params.fetch(:per_page, 20).to_i
    @page = params.fetch(:page, 0).to_i
    @page = @page - 1 unless @page == 0
  end
end
