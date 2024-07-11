class SearchSerializer 
  def self.format_search(items)
    {
      data: 
        items.map do |item|
          {
            id: item.id.to_s,
            type: "item",
            attributes:
            {
              name: item.name,
              description: item.description,
              unit_price: item.unit_price
            }
          }
        end
      
    }
  end
end