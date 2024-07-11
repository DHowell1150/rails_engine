class Api::V1::ItemsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :no_record_found

    def index
      if params[:merchant_id]
        @merchant = Merchant.find(params[:merchant_id])
        render json: ItemSerializer.new(@merchant.items)
      else
        items = Item.all
        render json: ItemSerializer.new(items)
      end
    end

    def show
      item = Item.find(params[:id])
      render json: ItemSerializer.new(item) 
    end

    def create
      begin
        item = Item.create!(item_params)
        render json: ItemSerializer.new(item), status: 201
      rescue ActiveRecord::RecordInvalid => e
        render json: ErrorSerializer.new(ErrorMessage.new(e.message, 422)).serialize_json, status: 422
      end   
    end

    def update
      begin
        item = Item.update!(params[:id], item_params)
        render json: ItemSerializer.new(item) 
      rescue ActiveRecord::RecordInvalid => e
        render json: ErrorSerializer.new(ErrorMessage.new(e.message, 422)).serialize_json, status: 422
      end   
    end
    
    def destroy
      item = Item.destroy(params[:id])
      render json: ItemSerializer.new(item)
    end

    def merchant
      item = Item.find(params[:item_id])
      render json: MerchantSerializer.new(item.merchant)
    end

    private
    
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

    def no_record_found(error)
      render json: ErrorSerializer.new(ErrorMessage.new(error.message, 404)).serialize_json, status: 404
    end
end