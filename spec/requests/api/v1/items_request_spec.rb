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

  it 'sends the data of a single item by id' do
    create(:merchant, id: 1)
    create_list(:item, 25, merchant_id: 1)

    get "/api/v1/items/#{Item.first.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item.count).to eq(1)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)
    expect(item[:data][:id]).to eq(Item.first.id.to_s)
    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to eq('item')
    expect(item[:data]).to have_key(:attributes)
    expect(item[:data][:attributes]).to be_a(Hash)
    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)
    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)
    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
  end

  describe 'Create an Item' do
    before :each do
      create(:merchant, id: 1)
      create_list(:item, 10, merchant_id: 1)
    end

    it 'can create and render a JSON representation of the new Item record' do
      expect(Item.count).to eq(10)

      body = {
        "name": "Name",
        "description": "description body",
        "unit_price": 100.99,
        "merchant_id": 1
      }
      post '/api/v1/items', params: body

      expect(response.status).to eq(201)
      expect(Item.count).to eq(11)

      new_item = JSON.parse(response.body, symbolize_names: true)

      expect(new_item[:data]).to have_key(:id)
      expect(new_item[:data][:id]).to be_a(String)
      expect(new_item[:data][:id]).to eq(Item.last.id.to_s)
      expect(new_item[:data]).to have_key(:type)
      expect(new_item[:data][:type]).to eq('item')
      expect(new_item[:data]).to have_key(:attributes)
      expect(new_item[:data][:attributes]).to be_a(Hash)
      expect(new_item[:data][:attributes]).to have_key(:name)
      expect(new_item[:data][:attributes][:name]).to be_a(String)
      expect(new_item[:data][:attributes]).to have_key(:description)
      expect(new_item[:data][:attributes][:description]).to be_a(String)
      expect(new_item[:data][:attributes]).to have_key(:unit_price)
      expect(new_item[:data][:attributes][:unit_price]).to be_a(Float)
    end

    it 'will return an error if any attribute is missing' do
      expect(Item.count).to eq(10)

      body = {
        "name": "Name",
        "unit_price": 100.99,
        "merchant_id": 1
      }
      post '/api/v1/items', params: body

      expect(response.status).to eq(406)
      expect(Item.count).to eq(10)
    end

    it 'will ignore any attributes sent by the user which are not allowed' do
      expect(Item.count).to eq(10)

      body = {
        "name":        "Name",
        "description": "Description body",
        "unit_price":   100.99,
        "merchant_id":  1,
        "extra_stuff": "Sooo extra"
      }
      post '/api/v1/items', params: body
      new_item = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(201)
      expect(Item.count).to eq(11)

      expect(new_item[:data]).to_not have_key(:extra_stuff)
      expect(new_item[:data]).to_not have_value("Sooo extra")
      expect(new_item[:data][:attributes]).to_not have_key(:extra_stuff)
      expect(new_item[:data][:attributes]).to_not have_value("Sooo extra")
    end
  end

  describe 'Update an Item' do
    before :each do
      create(:merchant, id: 1)
      create(:item, id: 1, merchant_id: 1, description: "Old description")
    end

    it 'updates the corresponding item with whichever valid attributes are provided by the user' do
      body = { "description": "New description" }
      patch "/api/v1/items/#{Item.first.id}", params: body

      expect(response.status).to eq(202)

      updated_item = JSON.parse(response.body, symbolize_names: true)

      expect(updated_item[:data][:id]).to eq("1")
      expect(updated_item[:data][:attributes][:description]).to eq("New description")
    end

    it 'returns an error if the merchant is not found' do
      body = { "description": "New description", "merchant_id": 2 }
      patch "/api/v1/items/#{Item.first.id}", params: body

      expect(response.status).to eq(404)

      updated_item = JSON.parse(response.body, symbolize_names: true)

      expect(updated_item[:error]).to eq("merchant does not exist")
    end
  end

  describe "destroy an item" do
    before :each do
      create(:merchant, id: 1)
      create(:item, id: 10, merchant_id: 1)
      create_list(:item, 9, merchant_id: 1)
    end

    it 'destroys the corresonding record and any associated data' do
      expect(Item.count).to eq(10)

      delete "/api/v1/items/10"

      expect(response.status).to eq(204)
      expect(Item.count).to eq(9)
      expect(response.body).to eq("")
    end

    it 'returns an error if the item is not found' do
      expect(Item.count).to eq(10)

      delete "/api/v1/items/11"
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(404)
      expect(Item.count).to eq(10)
      expect(body[:error]).to eq("record can not be found")
    end
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
