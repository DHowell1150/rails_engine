class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all
    render json: MerchantSerializer.new(merchants)
  end

  def show
    begin
      merchant = Merchant.find(params[:id])
      render json: MerchantSerializer.new(merchant)
    rescue ActiveRecord::RecordNotFound => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404)).serialize_json, status: :not_found
    end
  end

  def find
  if params[:name]
    merchant = Merchant.find_merchant_by_name(params[:name])
    if merchant.nil?
      render json: ErrorSerializer.new(ErrorMessage.new("Merchant not found", 404)).invalid_params, status: 404
    else
      render json: MerchantSerializer.new(merchant)
    end
  end
end
end