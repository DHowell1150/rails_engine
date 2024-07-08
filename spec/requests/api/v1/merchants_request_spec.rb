require 'rails_helper'

describe "Merchants API" do
    it "sends a list of merchants" do
        create_list(:merchant, 3)

        get '/api/v1/merchants'

        expect(response).to be_successful

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants.count).to eq(3)

        merchants.each do |merchant|
            expect(merchant).to have_key(:name)
            expect(merchant[:name]).to be_a String

            expect(merchant).to have_key(:id)
            expect(merchant[:id]).to be_an Integer
        end
    end

    it "can get one merchant by its id" do
        id = create(:merchant).id

        get "/api/v1/merchants/#{id}"

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful

        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to eq(id)

        expect(merchant).to have_key(:name)
        expect(merchant[:name]).to be_a(String)

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
        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful

        items.each do |item| 
            expect(item).to have_key(:name)
            expect(item[:name]).to be_a String

            expect(item).to have_key(:description)
            expect(item[:description]).to be_a String

            expect(item).to have_key(:unit_price)
            expect(item[:unit_price]).to be_a Float
        end
    end
end