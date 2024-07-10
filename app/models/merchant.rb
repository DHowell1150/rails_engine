class Merchant < ApplicationRecord
    has_many :items

    def self.find_merchant_by_name(name)
        where('lower(name) LIKE ?', "%#{name.downcase}%").order('lower(name)').first
    end
end