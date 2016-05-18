class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.timestamps
    end
    # assuming we can use merchant names as unique identifiers
    # this might be a wrong assumption, but the fate of our world now depends on it
    # if we come across a merchant with the same name, but different address?
    # could be an address change? could be same merchant other location? could be other merchant?
    add_index :merchants, :name, unique: true
  end
end
