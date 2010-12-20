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

ActiveRecord::Schema.define(:version => 20101219094909) do

  create_table "deals", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "eventful_delegates", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorite_maps", :force => true do |t|
    t.integer  "user_id"
    t.integer  "map_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "status"
    t.datetime "time_created"
    t.datetime "time_accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gmap_delegates", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "infos", :force => true do |t|
    t.integer  "user_id",                    :null => false
    t.string   "name",       :default => ""
    t.string   "location",   :default => ""
    t.string   "bio",        :default => ""
    t.string   "saved_maps", :default => ""
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
    t.decimal  "rating_average", :precision => 6, :scale => 2, :default => 0.0
  end

  create_table "passwird_delegates", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rates", :force => true do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "stars",         :null => false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id", "rateable_type"], :name => "index_rates_on_rateable_id_and_rateable_type"
  add_index "rates", ["rater_id"], :name => "index_rates_on_rater_id"

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
