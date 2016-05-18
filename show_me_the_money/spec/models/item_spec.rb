require 'rails_helper'

RSpec.describe Item, :type => :model do

  it "should be valid item if using default values" do
    item = build :item
    item.should be_valid
  end

  it "should be creatable if using default values" do
    item = create :item
    Item.count.should == 1
    item_db = Item.first
    item_db.class.name.should == "Item"
    item_db.description.should == item.description
    item_db.price.should == item.price
  end

  it "should not be creatable if using same values for description and price" do
    item = build :item, description: 'foo bar baz', price: 100
    item.save
    Item.count.should == 1
    item2 = build :item, description: 'foo bar baz', price: 100
    lambda { item2.save validate: false }.should raise_error
    Item.count.should == 1
  end

  it "should be creatable if using same values for description, but different price" do
    item = build :item, description: 'foo bar baz', price: 100
    item.save
    Item.count.should == 1
    item2 = build :item, description: 'foo bar baz', price: 200
    item2.save
    Item.count.should == 2
  end

  it "should be creatable if using same values for price, but different description" do
    item = build :item, description: 'foo bar baz', price: 100
    item.save
    Item.count.should == 1
    item2 = build :item, description: 'foo bar buz', price: 100
    item2.save
    Item.count.should == 2
  end

  it "should be invalid item if no description" do
    item = build :item, description: nil
    item.should be_invalid
  end

  it "should be invalid item if no price" do
    item = build :item, price: nil
    item.should be_invalid
  end

  it "should be invalid item if price not number" do
    item = build :item, price: "foo"
    item.should be_invalid
  end

  it "should be invalid item if price not > 0" do
    item = build :item, price: -10
    item.should be_invalid
  end

  it "should be invalid item if price is 0" do
    item = build :item, price: 0
    item.should be_invalid
  end

end
