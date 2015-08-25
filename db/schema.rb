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

ActiveRecord::Schema.define(version: 20150816212937) do

  create_table "exchanges", force: :cascade do |t|
    t.integer  "group_id",    limit: 4
    t.integer  "giver_id",    limit: 4
    t.integer  "receiver_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_people", force: :cascade do |t|
    t.integer  "group_id",             limit: 4
    t.integer  "person_id",            limit: 4
    t.text     "wishlist_description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: :cascade do |t|
    t.integer  "admin_id",    limit: 4
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "date"
    t.string   "location",    limit: 255
    t.string   "price_range", limit: 255
    t.integer  "status",      limit: 4,     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: ""
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "name",                   limit: 255
    t.string   "image",                  limit: 255
    t.string   "token",                  limit: 255
    t.string   "expires_at",             limit: 255
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",       limit: 4
    t.integer  "invited_by_id",          limit: 4
    t.string   "invited_by_type",        limit: 255
    t.integer  "invitations_count",      limit: 4,   default: 0
  end

  add_index "people", ["email"], name: "index_people_on_email", unique: true, using: :btree
  add_index "people", ["invitation_token"], name: "index_people_on_invitation_token", unique: true, using: :btree
  add_index "people", ["invitations_count"], name: "index_people_on_invitations_count", using: :btree
  add_index "people", ["invited_by_id"], name: "index_people_on_invited_by_id", using: :btree
  add_index "people", ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree

  create_table "wishlist_items", force: :cascade do |t|
    t.integer "group_person_id",  limit: 4
    t.text    "name_or_url",      limit: 65535
    t.text    "comments",         limit: 65535
    t.string  "image",            limit: 255
    t.string  "link_title",       limit: 255
    t.text    "link_description", limit: 65535
  end

end
