require 'rails_helper'

describe Merchant, type: :model do
    describe 'relationships' do
        it { should have_many :items }
    end
    
    describe 'class methods' do
        it 'find_merchant_by_name' do
        merchant1 = Merchant.create!(name: "Ring World")
        merchant2 = Merchant.create!(name: "Turing")
    
        expect(Merchant.find_merchant_by_name("ring")).to eq(merchant1)
        expect(Merchant.find_merchant_by_name("ring")).to_not eq(merchant2)
        end
    end
end