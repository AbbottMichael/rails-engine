require 'rails_helper'
require 'faker'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 44)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(20)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'sends the data of a single merchant by id' do
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

  it "sends a list of a merchant's items" do
    merchant = create(:merchant, id: 1)
    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)

    get "/api/v1/merchants/#{merchant.id}/items"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(3)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to eq(merchant.id)
    end
  end
end
