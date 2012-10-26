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

ActiveRecord::Schema.define(:version => 20121026104848) do

  create_table "composers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "evensongs", :force => true do |t|
    t.string   "title"
    t.integer  "psalm"
    t.integer  "composer_id"
    t.integer  "genre_id"
    t.string   "soloists"
    t.text     "comment"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "evensongs", ["composer_id"], :name => "index_evensongs_on_composer_id"
  add_index "evensongs", ["genre_id"], :name => "index_evensongs_on_genre_id"

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "links", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "evensong_id"
    t.integer  "note_id"
  end

  add_index "links", ["evensong_id"], :name => "index_links_on_evensong_id"
  add_index "links", ["note_id"], :name => "index_links_on_note_id"

  create_table "messages", :force => true do |t|
    t.string   "title",                          :null => false
    t.text     "content",                        :null => false
    t.datetime "startdt"
    t.datetime "enddt"
    t.boolean  "active_flag", :default => false, :null => false
    t.string   "msgtype",                        :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "note_language_assignments", :force => true do |t|
    t.integer  "note_id"
    t.integer  "language_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "note_language_assignments", ["language_id"], :name => "index_note_language_assignments_on_language_id"
  add_index "note_language_assignments", ["note_id"], :name => "index_note_language_assignments_on_note_id"

  create_table "notes", :force => true do |t|
    t.integer  "item"
    t.string   "title"
    t.integer  "originals"
    t.integer  "copies"
    t.integer  "instrumental"
    t.string   "voice"
    t.integer  "composer_id"
    t.integer  "genre_id"
    t.integer  "period_id"
    t.string   "instrument"
    t.string   "soloists"
    t.text     "comment"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "notes", ["composer_id"], :name => "index_notes_on_composer_id"
  add_index "notes", ["genre_id"], :name => "index_notes_on_genre_id"
  add_index "notes", ["period_id"], :name => "index_notes_on_period_id"

  create_table "periods", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "uploads", :force => true do |t|
    t.string   "title"
    t.string   "path"
    t.integer  "note_id"
    t.integer  "evensong_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "uploads", ["evensong_id"], :name => "index_uploads_on_evensong_id"
  add_index "uploads", ["note_id"], :name => "index_uploads_on_note_id"

  create_table "user_role_assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_role_assignments", ["role_id"], :name => "index_user_role_assignments_on_role_id"
  add_index "user_role_assignments", ["user_id"], :name => "index_user_role_assignments_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "persistence_token"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "datetime"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "onetime"
    t.string   "name"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

end
