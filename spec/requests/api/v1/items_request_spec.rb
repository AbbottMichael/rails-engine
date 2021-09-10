require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    create(:merchant, id: 1)
    create(:merchant, id: 2)
    create_list(:item, 25, merchant_id: 1)
    create_list(:item, 25, merchant_id: 2)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(20)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item).to have_key(:type)
      expect(item[:type]).to eq('item')
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  xit 'sends the data of a single merchant by id' do
    create_list(:merchant, 40)

    get "/api/v1/merchants/#{Merchant.first.id}"

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(1)

    expect(merchants[:data]).to have_key(:id)
    expect(merchants[:data][:id]).to be_a(String)
    expect(merchants[:data][:id]).to eq(Merchant.first.id.to_s)
    expect(merchants[:data]).to have_key(:type)
    expect(merchants[:data][:type]).to be_a(String)
    expect(merchants[:data]).to have_key(:attributes)
    expect(merchants[:data][:attributes]).to be_a(Hash)
    expect(merchants[:data][:attributes]).to have_key(:name)
    expect(merchants[:data][:attributes][:name]).to be_a(String)
    expect(merchants[:data][:attributes][:name]).to eq(Merchant.first.name)
  end

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
      expect(items[:data].any? {|item| item[:id] == @item1.id.to_s}).to eq(true)
      expect(items[:data].any? {|item| item[:id] == @item2.id.to_s}).to eq(true)
      expect(items[:data].any? {|item| item[:id] == @item3.id.to_s}).to eq(true)
      expect(items[:data].any? {|item| item[:id] == @item4.id.to_s}).to eq(false)
      expect(items[:data].any? {|item| item[:id] == @item5.id.to_s}).to eq(false)
    end
  end

  describe 'items ranked by descending revenue' do
    before :each do
      @customer1 = create(:customer)
      @merchant1 = create(:merchant)
      @item1 = create(:item, merchant_id: @merchant1.id)
      @invoice1 = create(:invoice, merchant_id: @merchant1.id, customer_id: @customer1.id)
      create(:invoice_item, item_id: @item1.id, invoice_id: @invoice1.id)
      create(:transaction, invoice_id: @invoice1.id)
      @invoice2 = create(:invoice, merchant_id: @merchant1.id, customer_id: @customer1.id)
      create(:invoice_item, item_id: @item1.id, invoice_id: @invoice2.id)
      create(:transaction, invoice_id: @invoice2.id)
      @merchant2 = create(:merchant)
      @item2 = create(:item, merchant_id: @merchant2.id)
      @invoice3 = create(:invoice, merchant_id: @merchant2.id, customer_id: @customer1.id)
      create(:invoice_item, quantity: 200, item_id: @item2.id, invoice_id: @invoice3.id)
      create(:transaction, invoice_id: @invoice3.id)
      @invoice4 = create(:invoice, merchant_id: @merchant2.id, customer_id: @customer1.id)
      create(:invoice_item, item_id: @item2.id, invoice_id: @invoice4.id)
      create(:transaction, invoice_id: @invoice4.id)
    end

    it 'sends back a chosen number of items ranked by revenue in descending order' do
      get "/api/v1/revenue/items?quantity=1"
      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(1)

      get "/api/v1/revenue/items?quantity=2"
      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(2)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        expect(item).to have_key(:type)
        expect(item[:type]).to eq('item_revenue')
        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a(Hash)
        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)
        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
        expect(item[:attributes]).to have_key(:revenue)
        expect(item[:attributes][:revenue]).to be_a(Float)
      end
    end
  end
end
