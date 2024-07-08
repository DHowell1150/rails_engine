require 'rails_helper'

describe "items API" do
  it "sends a list of items" do
    merchant = create(:merchant)

    item_1 = Item.create!(
        name: "toothbrush",
        description: "thing",
        unit_price: 1.5,
        merchant_id: merchant.id
    )
    item_2 = Item.create!(
        name: "paste",
        description: "thing",
        unit_price: 1.5,
        merchant_id: merchant.id
    )
    item_3 = Item.create!(
        name: "floss",
        description: "thing",
        unit_price: 1.5,
        merchant_id: merchant.id
    )

    items = [item_1, item_2, item_3]

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.count).to eq(3)

    items.each do |item| 
      expect(item).to have_key(:name)
      expect(item[:name]).to be_a String

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a String

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a Float
    end
  end

  it "can get one item by its id" do
    merchant = create(:merchant)

    item_1 = Item.create!(
        name: "toothbrush",
        description: "thing",
        unit_price: 1.5,
        merchant_id: merchant.id
    )

    get "/api/v1/items/#{item_1.id}"
    item_1 = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item_1).to have_key(:name)
    expect(item_1[:name]).to be_a String

    expect(item_1).to have_key(:description)
    expect(item_1[:description]).to be_a String

    expect(item_1).to have_key(:unit_price)
    expect(item_1[:unit_price]).to be_a Float
  end

  it "can create a new item" do
    merchant = create(:merchant)

    item_params = ({
      name: "paste",
      description: "thing",
      unit_price: 1.5,
      merchant_id: merchant.id
      })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(merchant.id)
  end

  it "can update an existing item" do
    merchant = create(:merchant)
    item_2 = Item.create!(
      name: "paste",
      description: "thing",
      unit_price: 1.5,
      merchant_id: merchant.id
    )
    
    previous_name = Item.last.name
    
    item_params = {name: "Toothpaste"}
    headers = {"CONTENT_TYPE" => "application/json"}
    patch "/api/v1/items/#{item_2.id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: item_2.id)  

    expect(response).to be_successful
    expect(item.name).not_to eq(previous_name)
    expect(item.name).to eq("Toothpaste")
  end

  it "can destroy an item" do
    merchant = create(:merchant)
    item_2 = Item.create!(
      name: "paste",
      description: "thing",
      unit_price: 1.5,
      merchant_id: merchant.id
    )
    expect{ delete "/api/v1/items/#{item_2.id}" }.to change(Item, :count).by(-1) # why the hash?
    expect{Item.find(item_2.id)}.to raise_error(ActiveRecord::RecordNotFound) # why  hash after expect?
  end
end