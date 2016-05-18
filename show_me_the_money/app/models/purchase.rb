class Purchase < ActiveRecord::Base
  attr_accessible :purchaser_name, :count, :item, :merchant

  belongs_to :item, inverse_of: :purchases
  belongs_to :merchant, inverse_of: :purchases
  
  validates :purchaser_name, presence: true
  validates :count, presence: true, numericality: { greater_than: 0 }
  validates :item, presence: true
  validates :merchant, presence: true

  # parse the data as read from the file (array of arrays, including header row)
  def self.parse_data(data)
    #binding.pry
    sum = 0
    data.each_with_index do |row, i|
      next if i == 0 # ignore header row
      purchaser_name, item_description, item_price, purchase_count, merchant_address, merchant_name = row
      merchant = Merchant.find_or_create_by_name(merchant_name, { address: merchant_address })
      price = (item_price.to_f * 100).to_i # use integer in database (in cents)
      amount = price * purchase_count.to_i
      item = Item.find_or_create_by_description_and_price(description: item_description, price: price)
      Purchase.create item: item, merchant: merchant, purchaser_name: purchaser_name, count: purchase_count.to_i
      sum += amount
    end
    sum/100.0 # return as float (in dollars, rather than cents)
  end
end

# TODO: item will get merchant id, purchase will not... update tests, too