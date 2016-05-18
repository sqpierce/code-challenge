require 'rails_helper'

# this might ultimately want to be in spec helper...
# generate an array of arrays of valid data, as per spec, to pass to Purchase.parse_data.
# this kind of thing is a great application for QuickCheck (http://www.haskell.org/haskellwiki/Introduction_to_QuickCheck1)
# for which there is a ruby equivalent: (https://github.com/hayeah/rantly)
# but considering that beyond the scope of this project.
def generate_test_data
  headerrow = ['foo', 'bar', 'baz', 'qux', 'quy', 'quz'] # contents inconsequential
  merchant_name = "foo bar" # use for occassional repetition
  item_description = "baz qux"
  item_price = 100
  # proc to generate a row of data with occassional repetition as per values above
  rowgen = Proc.new { [Faker::Name.name, [Faker::Commerce.product_name, item_description].sample, [Faker::Number.number(3), item_price].sample, (1..100).to_a.sample, Faker::Address.street_address, [Faker::Company.name, merchant_name].sample] }
  data = [ headerrow ]
  (0..(rand(100)+20)).each{ data << rowgen.call } # generate random number of rows
  data
end

def analyze_test_data(data)
  sum = 0
  merchants = {}
  items = {}
  data.each_with_index do |row, i|
    next if i == 0 # skip header row
    sum += (row[2].to_f * row[3].to_i) # price * count
    items["#{row[1]}:#{row[2]}"] = 1 # use unique hash keys to collect items, merchants
    merchants[row[5]] = 1
  end
  { sum: sum, item_count: items.keys.size, merchant_count: merchants.keys.size }
end

RSpec.describe Purchase, :type => :model do

  it "should be valid purchase if using default values" do
    item = build :purchase
    item.should be_valid
  end

  it "should be creatable if using default values" do
    purchase = create :purchase
    Purchase.count.should == 1
    Item.count.should == 1
    Merchant.count.should == 1
    purchase_db = Purchase.first
    purchase_db.class.name.should == "Purchase"
    purchase_db.purchaser_name.should == purchase.purchaser_name
    purchase_db.count.should == purchase.count
    purchase_db.item.should == purchase.item
    purchase_db.item.class.name.should == "Item"
    purchase_db.merchant.should == purchase.merchant
    purchase_db.merchant.class.name.should == "Merchant"
  end

  it "should be invalid purchase if no purchaser name" do
    item = build :purchase, purchaser_name: nil
    item.should be_invalid
  end

  it "should be invalid purchase if no count" do
    item = build :purchase, count: nil
    item.should be_invalid
  end

  it "should be invalid purchase if count not > 0" do
    item = build :purchase, count: -10
    item.should be_invalid
  end

  it "should be invalid purchase if count is 0" do
    item = build :purchase, count: 0
    item.should be_invalid
  end

  it "should be invalid purchase if no item" do
    item = build :purchase, item: nil
    item.should be_invalid
  end

  it "should be invalid purchase if no merchant" do
    item = build :purchase, merchant: nil
    item.should be_invalid
  end
  
  # this test will operate on different data each time its run, giving extra assurance
  it "should parse data, create appropriate db records, and return correct sum of purchases" do
    data = generate_test_data
    num_rows = data.size - 1 # we should see as many purchases as size of data minus the header row
    data_info = analyze_test_data(data)
    Purchase.parse_data(data).should == data_info[:sum]
    Purchase.count.should == num_rows
    Item.count.should == data_info[:item_count]
    Merchant.count.should == data_info[:merchant_count]

    # check for good purchase values
    Purchase.all.map{ |p| [p.purchaser_name, p.count] } =~ (data.map{ |row| [row[0], row[3]] })

    # now, we'll do it again, with the same data, should add purchases, but not items or merchants
    Purchase.parse_data(data).should == data_info[:sum]
    Purchase.count.should == num_rows * 2
    Item.count.should == data_info[:item_count]
    Merchant.count.should == data_info[:merchant_count]
    
    # check for good merchant values
    Merchant.pluck(:name) =~ data.map{ |row| row[5] }
    
    # check for good item values
    Item.all.map{ |i| [i.description, i.price] } =~ data.map{ |row| [row[1], row[2]] }
  end

end
