# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101223043233) do

  create_table "bensbargains_delegates", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bfads_delegates", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deal_adapters", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deals", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "guid"
    t.string   "source"
    t.string   "category"
    t.string   "buy_link"
    t.datetime "publish_date"
    t.string   "stashflip_status"
    t.string   "permadeal"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "cost",               :precision => 6, :scale => 2, :default => 0.0
    t.decimal  "cost_retail",        :precision => 6, :scale => 2, :default => 0.0
    t.decimal  "profit_margin",      :precision => 6, :scale => 2, :default => 0.0
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "eventful_delegates", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fatwallet_delegates", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorite_maps", :force => true do |t|
    t.integer  "user_id"
    t.integer  "map_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gmap_delegates", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "map_filters", :force => true do |t|
    t.integer  "map_id"
    t.string   "query"
    t.string   "location"
    t.string   "category"
    t.string   "add_nodes"
    t.string   "exclude_nodes"
    t.integer  "num_ratings_weight"
    t.integer  "avg_rating_weight"
    t.integer  "cheapness_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "maps", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.integer  "permission"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "passwird_delegates", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "yelp_delegates", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
