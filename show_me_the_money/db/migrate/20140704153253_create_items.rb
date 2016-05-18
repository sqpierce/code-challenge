# Note: there were various ways to interpret items as they relate to merchants and purchases.
# It could have been assumed that an item with a given description should be associated with a merchant.
# Choosing not to assume any relationship between items and merchants is necessary.
# We will assume that items can be normalized provided they are unique by description and price.

class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :description, null: false
      # using integer for money value to avoid floating point issues as discussed here:
      # http://stackoverflow.com/questions/1019939/ruby-on-rails-best-method-of-handling-currency-money
      t.integer :price, null: false
      t.timestamps
    end
    # will assume description, price pairs can be unique
    add_index :items, [:description, :price], unique: true
  end
end
