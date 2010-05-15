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

ActiveRecord::Schema.define(:version => 20100515171258) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.integer  "place_id"
    t.string   "url",             :limit => 2048
    t.string   "image_file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", :force => true do |t|
    t.string   "name"
    t.string   "location"
    t.integer  "source_id"
    t.integer  "category_id"
    t.integer  "primary_image_id"
    t.integer  "system_quality"
    t.integer  "user_quality"
    t.text     "description"
    t.decimal  "lat",              :precision => 15, :scale => 10
    t.decimal  "lng",              :precision => 15, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sources", :force => true do |t|
    t.string   "url"
    t.string   "name"
    t.string   "icon_filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "persistence_token"
    t.integer  "facebook_uid",         :limit => 8, :null => false
    t.string   "facebook_session_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["facebook_uid"], :name => "index_users_on_facebook_uid"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

  create_table "visits", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "place_id",                      :null => false
    t.boolean  "pending",    :default => true
    t.boolean  "visited",    :default => false
    t.boolean  "shared",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "visits", ["place_id"], :name => "index_visits_on_place_id"
  add_index "visits", ["user_id"], :name => "index_visits_on_user_id"

  create_table "webpages", :force => true do |t|
    t.integer  "source_id"
    t.integer  "place_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
