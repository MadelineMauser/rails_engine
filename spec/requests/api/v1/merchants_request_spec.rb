require 'rails_helper'

describe "Merchants API" do
  it "sends a list of all merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    response_hash = JSON.parse(response.body, symbolize_names: true)
    merchants = response_hash[:data]
    
    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end
  it "sends one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)
    
    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to eq("#{id}")

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end
end