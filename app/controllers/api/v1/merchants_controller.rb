class Api::V1::MerchantsController < ApplicationController
    def index
        merchants = Merchant.all
        render json: MerchantSerializer.new(merchants)
    end

    def show
        merchant = Merchant.find(params[:id])
        render json: MerchantSerializer.new(merchant)
    end

    def find
        if params[:name]
            merchant = Merchant.find_merchant_by_name(params[:name])
            render json: MerchantSerializer.new(merchant)
        end
    end
end