# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140704153259) do

  create_table "items", :force => true do |t|
    t.string   "description", :null => false
    t.integer  "price",       :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "items", ["description", "price"], :name => "index_items_on_description_and_price", :unique => true

  create_table "merchants", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "address",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "merchants", ["name"], :name => "index_merchants_on_name", :unique => true

  create_table "purchases", :force => true do |t|
    t.string   "purchaser_name", :null => false
    t.integer  "count",          :null => false
    t.integer  "item_id",        :null => false
    t.integer  "merchant_id",    :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "purchases", ["item_id"], :name => "index_purchases_on_item_id"
  add_index "purchases", ["merchant_id"], :name => "index_purchases_on_merchant_id"
  add_index "purchases", ["purchaser_name"], :name => "index_purchases_on_purchaser_name"

end
