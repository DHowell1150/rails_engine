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

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(3)

    items.each do |item| 
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a String

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a String

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a Float
    end
  end

  describe "can get one item by its id" do
    it "happy path" do
      merchant = create(:merchant)

      item_1 = Item.create!(
          name: "toothbrush",
          description: "thing",
          unit_price: 1.5,
          merchant_id: merchant.id
      )

      get "/api/v1/items/#{item_1.id}"
      item_1 = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful

      expect(item_1[:attributes]).to have_key(:name)
      expect(item_1[:attributes][:name]).to be_a String

      expect(item_1[:attributes]).to have_key(:description)
      expect(item_1[:attributes][:description]).to be_a String

      expect(item_1[:attributes]).to have_key(:unit_price)
      expect(item_1[:attributes][:unit_price]).to be_a Float
    end

    it "sad path" do
      get "/api/v1/items/123123"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Item with 'id'=123123")
    end
  end

  describe "can create a new item" do
    it "happy path" do
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

    it "returns a 422 status and error message when missing any required attribute" do  
      item_params = (
        {
          name: "string",
          description: "long",
          unit_price: 10.0
          
        }
      )

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:status]).to eq("422")
      expect(data[:errors].first[:title]).to eq("Validation failed: Merchant must exist, Merchant can't be blank")
    end
  end

  describe "can update an existing item" do
    it "happy path" do
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

    it "sad path" do
      item_params = { description: "Char" }
      headers = {"CONTENT_TYPE" => "application/json"}
    
      # We include this header to make sure that these params are passed as JSON rather than as plain text
      patch "/api/v1/items/1", headers: headers, params: JSON.generate({item: item_params})

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Item with 'id'=1")
    end

    it "sad path 2" do
      item_id = create(:item).id
      item_params = (
        {
          merchant_id: 1  
        }
      )

      headers = {"CONTENT_TYPE" => "application/json"}

      put "/api/v1/items/#{item_id}", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:status]).to eq("422")
      expect(data[:errors].first[:title]).to eq("Validation failed: Merchant must exist")
    end
  end

  describe "can destroy an item" do
    it "happy path" do
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

    it "sad path" do
      item_params = { name: "paste",
                      description: "thing",
                      unit_price: 1.5,
                      merchant_id: 1
      }
      headers = {"CONTENT_TYPE" => "application/json"}
    
      # We include this header to make sure that these params are passed as JSON rather than as plain text
      delete "/api/v1/items/1", headers: headers, params: JSON.generate({item: item_params})

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Item with 'id'=1")
    end
  end
end