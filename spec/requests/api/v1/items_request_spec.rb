require 'rails_helper'

describe "Items API" do
  it "sends a list of all items" do
    create_list(:items, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    response_hash = JSON.parse(response.body, symbolize_names: true)
    items = response_hash[:data]
    
    expect(items.count).to eq(3)

    items.each do |item|
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes]).to have_key(:price)
      expect(item[:attributes][:name]).to be_a(Float)
    end
  end
  it "sends one item by its id" do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)
    
    expect(item).to have_key(:id)
    expect(item[:id]).to eq(id)

    expect(item).to have_key(:name)
    expect(item[:name]).to be_a(String)
    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:name]).to be_a(String)
    expect(item[:attributes]).to have_key(:price)
    expect(item[:attributes][:name]).to be_a(Float)
  end
  it "can create a new item" do
    item_params = {name: 'Rubber Ball', description: 'A bouncy ball.', price: 1.05}
    headers = {"CONTENT_TYPE" => "application/json"}
    
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last
    
    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
  end
  it "can update a item" do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = {name: "Super Ball" }
    headers = {"CONTENT_TYPE" => "application/json"}
    
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)

    item = Item.find(id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq(item_params[:name])
  end
  it "can delete a item" do
    id = create(:item).id

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{id}"
   
    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end