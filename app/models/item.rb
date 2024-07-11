class Item < ApplicationRecord
    belongs_to :merchant

    validates :name, presence: true
    validates :description, presence: true
    validates :unit_price, presence: true
    validates :merchant_id, presence: true

    def self.find_items_by_name(name)
        where('lower(name) LIKE ?', "%#{name.downcase}%").order('lower(name)').first
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
end