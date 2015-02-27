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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140502074948) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "composers", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "notes_count",                 default: 0, null: false
    t.integer  "evensongs_count",             default: 0, null: false
  end

  create_table "evensongs", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.integer  "psalm"
    t.integer  "composer_id"
    t.integer  "genre_id"
    t.string   "soloists",    limit: 255
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "evensongs", ["composer_id"], name: "index_evensongs_on_composer_id", using: :btree
  add_index "evensongs", ["genre_id"], name: "index_evensongs_on_genre_id", using: :btree

  create_table "genres", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "notes_count",                 default: 0, null: false
    t.integer  "evensongs_count",             default: 0, null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "notes_count",             default: 0, null: false
  end

  create_table "links", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "url",         limit: 255
    t.integer  "evensong_id"
    t.integer  "note_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["evensong_id"], name: "index_links_on_evensong_id", using: :btree
  add_index "links", ["note_id"], name: "index_links_on_note_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "title",       limit: 255,                 null: false
    t.text     "content",                                 null: false
    t.datetime "startdt"
    t.datetime "enddt"
    t.boolean  "active_flag",             default: false, null: false
    t.string   "msgtype",     limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "item"
    t.string   "title",        limit: 255
    t.integer  "originals"
    t.integer  "copies"
    t.integer  "instrumental"
    t.string   "voice",        limit: 255
    t.integer  "composer_id"
    t.integer  "genre_id"
    t.integer  "period_id"
    t.string   "instrument",   limit: 255
    t.string   "soloists",     limit: 255
    t.text     "comment"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["composer_id"], name: "index_notes_on_composer_id", using: :btree
  add_index "notes", ["genre_id"], name: "index_notes_on_genre_id", using: :btree
  add_index "notes", ["language_id"], name: "index_notes_on_language_id", using: :btree
  add_index "notes", ["period_id"], name: "index_notes_on_period_id", using: :btree

  create_table "periods", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "notes_count",             default: 0, null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploads", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "path",        limit: 255
    t.integer  "note_id"
    t.integer  "evensong_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uploads", ["evensong_id"], name: "index_uploads_on_evensong_id", using: :btree
  add_index "uploads", ["note_id"], name: "index_uploads_on_note_id", using: :btree

  create_table "user_role_relations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_role_relations", ["role_id"], name: "index_user_role_relations_on_role_id", using: :btree
  add_index "user_role_relations", ["user_id"], name: "index_user_role_relations_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 255
    t.string   "name",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
