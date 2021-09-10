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

  def destroy
    item = Item.where(id: params[:id])
    (item == []) ? (no_record_error) : (item[0].destroy)
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render status: :accepted, json: ItemSerializer.new(item)
    elsif Merchant.where(id: params[:merchant_id]) == []
      no_merchant_error
    else
      invalid_data_error
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

  def invalid_data_error
    render json: { error: "must provide valid data" }, status: :not_acceptable
  end

  def no_merchant_error
    render json: { error: "merchant does not exist" }, status: :not_found
  end

  def id_error
    render json: { error: "must provide a valid id" }, status: :bad_request
  end

  def no_record_error
    render json: { error: "record can not be found" }, status: :not_found
  end
end
