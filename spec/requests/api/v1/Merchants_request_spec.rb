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
end
