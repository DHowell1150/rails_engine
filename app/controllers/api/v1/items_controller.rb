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
      item = Item.update!(params[:id], item_params)
      render json: ItemSerializer.new(item) 
    end
    
    def destroy
      item = Item.destroy(params[:id])
      render json: ItemSerializer.new(item) 
      # begin
      # rescue ActiveModel::ValidationError => exception
      #   #render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400)).serialize_json, status: 400
      # end 
    end

    def find_all
      if params[:name] && (params[:min_price] || params[:max_price])
        render json: ErrorSerializer.new.invalid_parameters(ErrorMessage("Too many Parameters", 400))
      elsif params[:name]
        # items = Item.find_items_by_name(params[:name])
        # require 'pry' ; binding.pry
        # render json: SearchSerializer.format_search(items)
        items = []
        item = Item.find_items_by_name(params[:name])
        items << item
        render json: ItemSerializer.new(items)

      elsif params[:min_price] || params[:max_price]
        items = Item.find_by_min_max(params[:min_price], params[:max_price])
        items = Item.find_by_min_price(params[:min_price]) if params[:min_price]
        items = Item.find_by_max_price(params[:max_price]) if params[:max_price]

   
        render json: SearchSerializer.format_search(items)
      else 
        render json: ErrorSerializer.new.invalid_parameters(ErrorMessage("Wrong Parameters", 400))
      end
    end

    private
    
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

    def no_record_found(error)
      render json: ErrorSerializer.new(ErrorMessage.new(error.message, 404)).serialize_json, status: 404
    end
end