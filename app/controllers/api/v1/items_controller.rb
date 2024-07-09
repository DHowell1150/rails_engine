class Api::V1::ItemsController < ApplicationController
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
        item = Item.create(item_params)
        render json: ItemSerializer.new(item)
    end

    def update
        item = Item.update(params[:id], item_params)
        render json: ItemSerializer.new(item)
    end

    def destroy
        item = Item.destroy(params[:id])
        render json: ItemSerializer.new(item)
        
    end

    private
    
    def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end