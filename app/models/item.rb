class Item < ApplicationRecord
    belongs_to :merchant

    validates :name, presence: true
    validates :description, presence: true
    validates :unit_price, presence: true
    validates :merchant_id, presence: true

    def self.find_items_by_name(name)
        where('lower(name) LIKE ?', "%#{name.downcase}%").order('lower(name)')
    end

    def self.find_by_min_max(price1, price2)
        where('unit_price >= ?', price1).where('unit_price <= ?', price2)    
    end

    def self.find_by_min_price(price)
        where('unit_price >= ?', price)
    end

    def self.find_by_max_price(price)
        where('unit_price <= ?', price)
    end

    def self.find_all_items(params)
        if params[:name]
            find_items_by_name(params[:name])
        elsif params[:min_price] && params[:max_price]
            find_by_min_max(params[:min_price], params[:max_price])
        elsif params[:min_price]
            find_by_min_price(params[:min_price])
        elsif params[:max_price]
            find_by_max_price(params[:max_price])
        else
            raise ArgumentError.new('Wrong Parameters')
        end
    end

    def self.check_request(params)
        if params[:name] && (params[:min_price] || params[:max_price])
            { error: 'Too many Parameters', status: 400 }
        elsif params[:min_price] && params[:min_price].to_i < 0
            { error: 'min_price must be greater than or equal to 0', status: 400 }
        elsif params[:max_price] && params[:max_price].to_i < 0
            { error: 'max_price must be greater than or equal to 0', status: 400 }
        else
            find_all_items(params)
        end
    end
end