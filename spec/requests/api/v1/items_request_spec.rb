require 'rails_helper'

describe 'Items API' do
  describe 'Find all items' do
    before :each do
      @merchant = create(:merchant)
      @item1 = create(:item, name: 'Super stuff', merchant: @merchant)
      @item2 = create(:item, name: 'Stuff super', merchant: @merchant)
      @item3 = create(:item, name: 'Asuperlicious', merchant: @merchant)
      @item4 = create(:item, name: 'Lame', merchant: @merchant)
      @item5 = create(:item, name: 'Lame too', merchant: @merchant)
    end

    it 'sends back all items, based on a name query' do
      param = 'super'
      get "/api/v1/items/find_all?name=#{param}"
      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(3)
      expect(items[:data].any? {|x| x[:id] == @item1.id.to_s}).to eq(true)
      expect(items[:data].any? {|x| x[:id] == @item2.id.to_s}).to eq(true)
      expect(items[:data].any? {|x| x[:id] == @item3.id.to_s}).to eq(true)
      expect(items[:data].any? {|x| x[:id] == @item4.id.to_s}).to eq(false)
      expect(items[:data].any? {|x| x[:id] == @item5.id.to_s}).to eq(false)
    end
  end
end
