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

ActiveRecord::Schema.define(version: 20140401130157) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "permission_roles", force: true do |t|
    t.integer "permission_id"
    t.integer "role_id"
  end

  add_index "permission_roles", ["permission_id", "role_id"], name: "by_permission_role", using: :btree

  create_table "permissions", force: true do |t|
    t.string   "action"
    t.string   "subject_class"
    t.integer  "subject_id"
    t.string   "condition"
    t.text     "block"
    t.boolean  "cannot",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_translations", force: true do |t|
    t.integer  "role_id",    null: false
    t.string   "locale",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "role_translations", ["locale"], name: "index_role_translations_on_locale", using: :btree
  add_index "role_translations", ["role_id"], name: "index_role_translations_on_role_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name",        limit: 40
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count"
    t.integer  "status"
    t.string   "verifable_type"
    t.datetime "last_request_at"
    t.string   "perishable_token",   default: "", null: false
    t.integer  "failed_login_count"
    t.text     "preferences"
    t.integer  "role_id"
    t.integer  "verifable_id"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["verifable_id"], name: "by_verifable", using: :btree

  create_table "years", force: true do |t|
    t.string   "name"
    t.boolean  "locked",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
