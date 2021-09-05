require 'rails_helper'
require 'faker'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 2)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(2)

    merchants.each do |merchant|
      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_an(String)
    end
  end
end
