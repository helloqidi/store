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

ActiveRecord::Schema.define(:version => 12) do

  create_table "categories", :force => true do |t|
    t.string   "name",                    :null => false
    t.integer  "parent_id",               :null => false
    t.integer  "level",      :limit => 3, :null => false
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "items", :force => true do |t|
    t.string   "title",                           :null => false
    t.text     "description", :limit => 16777215, :null => false
    t.integer  "status",      :limit => 3,        :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "photos", :force => true do |t|
    t.integer  "related_id"
    t.string   "file",                     :null => false
    t.integer  "sort",       :limit => 3,  :null => false
    t.string   "file_type",  :limit => 10
    t.integer  "file_size"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "quote",      :limit => 1
  end

  create_table "recommends", :force => true do |t|
    t.string   "title",                              :null => false
    t.string   "sub_title"
    t.text     "description",  :limit => 16777215,   :null => false
    t.integer  "status",       :limit => 3,          :null => false
    t.integer  "sort",         :limit => 3,          :null => false
    t.string   "tags"
    t.integer  "category_id",                        :null => false
    t.integer  "user_id",                            :null => false
    t.string   "store_url"
    t.string   "store_name"
    t.integer  "comment_cnt"
    t.integer  "up_cnt"
    t.integer  "down_cnt"
    t.integer  "favorite_cnt"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.text     "desc_text",    :limit => 2147483647
  end

  create_table "users", :force => true do |t|
    t.string   "name",             :limit => 100, :null => false
    t.string   "email",            :limit => 100, :null => false
    t.string   "crypted_password",                :null => false
    t.integer  "role",             :limit => 3,   :null => false
    t.string   "ip",               :limit => 100
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "avatar"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
