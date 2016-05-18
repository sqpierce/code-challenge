class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      # no point having a separate "purchasers" table, as all we have is a name,
      # and repeated names won't necessarily always belong to the same person.
      t.string :purchaser_name, null: false
      t.integer :count, null: false
      t.integer :item_id, null: false
      t.integer :merchant_id, null: false
      t.timestamps
    end
    # not assuming purchaser names are unique (see note above)
    # nonetheless, we may want to look up by purchaser name
    add_index :purchases, :purchaser_name
    add_index :purchases, :item_id
    add_index :purchases, :merchant_id
  end
end
