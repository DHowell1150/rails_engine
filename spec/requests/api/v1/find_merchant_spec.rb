require "rails_helper"

RSpec.describe 'Find Merchant API' do
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