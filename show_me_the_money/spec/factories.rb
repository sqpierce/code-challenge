require 'faker'

FactoryGirl.define do
  factory :item do
    description Faker::Commerce.product_name
    price  Faker::Number.number(3)
  end

  factory :merchant do
    name Faker::Company.name
    address Faker::Address.street_address
  end

  factory :purchase do
    purchaser_name Faker::Name.name
    count  (1..100).to_a.sample # was having issue with Faker::Number (possibly was using 0)
    merchant { build :merchant }
    item { build :item }
  end

end