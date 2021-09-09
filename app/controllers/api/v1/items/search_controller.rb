class Api::V1::Items::SearchController < ApplicationController

  def index
    return (render status: :bad_request) if params[:name] == nil || params[:name].empty?
    render json: ItemSerializer.new(Item.find_all_items(params[:name]))
  end
end
