class Merchant < ActiveRecord::Base
  attr_accessible :name, :address

  has_many :purchases, inverse_of: :item
  
  validates :name, presence: { unique: true }
  validates :address, presence: true
end
