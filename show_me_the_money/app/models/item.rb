class Item < ActiveRecord::Base
  attr_accessible :description, :price
  
  has_many :purchases, inverse_of: :item
  
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  
end
