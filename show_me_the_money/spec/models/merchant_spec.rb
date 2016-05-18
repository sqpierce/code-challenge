require 'rails_helper'

RSpec.describe Merchant, :type => :model do

  it "should be valid merchant if using default values" do
    item = build :merchant
    item.should be_valid
  end

  it "should be creatable if using default values" do
    merchant = create :merchant
    Merchant.count.should == 1
    merchant_db = Merchant.first
    merchant_db.class.name.should == "Merchant"
    merchant_db.name.should == merchant.name
    merchant_db.address.should == merchant.address
  end

  it "should not be saveable if same name" do
    merchant = build :merchant, name: 'foo'
    merchant.save
    Merchant.count.should == 1
    merchant2 = build :merchant, name: 'foo'
    merchant.save
    Merchant.count.should == 1
  end

  it "should be invalid merchant if no name" do
    item = build :merchant, name: nil
    item.should be_invalid
  end

end