require 'rails_helper'

describe "Merchants API" do
    it "sends a list of merchants" do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchants.count).to eq(3)

      merchants.each do |merchant|
        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a String

        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an String

        expect(merchant).to have_key(:type)
        expect(merchant[:type]).to eq("merchant")

        expect(merchant).to have_key(:attributes)
        expect(merchant[:attributes]).to be_a Hash
      end
    end

    describe "can get one merchant by its id" do
      it "happpy path" do
        id = create(:merchant).id

        get "/api/v1/merchants/#{id}"

        merchant = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to be_successful

        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_a(String)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end

      it "sad path" do
        get "/api/v1/merchants/123123"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data[:errors]).to be_an(Array)
        expect(data[:errors].first[:status]).to eq("404")
        expect(data[:errors].first[:title]).to eq("Couldn't find Merchant with 'id'=123123")
      end
    end

    it "can get items for a specific merchant" do
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

        get "/api/v1/merchants/#{merchant.id}/items"
        items = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to be_successful

        items.each do |item| 
          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes][:name]).to be_a String

          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes][:description]).to be_a String

          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes][:unit_price]).to be_a Float
        end
    end
    it 'can find a single merchant by name in alphabetical order' do
        merchant1 = Merchant.create!(name: "Ring World")
        merchant2 = Merchant.create!(name: "Turing")


        get '/api/v1/merchants/find?name=ring'

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(json[:id].to_i).to eq(merchant1.id)
        expect(json[:attributes][:name]).to eq(merchant1.name)
        expect(json[:id].to_i).to_not eq(merchant2.id)
    end
    
    it 'can find a single merchant by name case-insensitive' do
        merchant1 = Merchant.create!(name: "Ring World")
        merchant2 = Merchant.create!(name: "Turing")

        get "/api/v1/merchants/find?name=RiNg"

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(json[:id].to_i).to eq(merchant1.id)
        expect(json[:attributes][:name]).to eq(merchant1.name)
        expect(json[:id].to_i).to_not eq(merchant2.id)
    end
end