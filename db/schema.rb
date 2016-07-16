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

ActiveRecord::Schema.define(version: 20160716191640) do

  create_table "calendars", force: :cascade do |t|
    t.string   "google_id"
    t.integer  "cuco_session_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "members_only"
  end

  add_index "calendars", ["cuco_session_id"], name: "index_calendars_on_cuco_session_id"

  create_table "courses", force: :cascade do |t|
    t.string   "title"
    t.string   "short_title"
    t.text     "description"
    t.integer  "min_age"
    t.integer  "max_age"
    t.boolean  "age_firm"
    t.integer  "min_students"
    t.integer  "max_students"
    t.float    "fee"
    t.text     "supplies"
    t.text     "room_reqs"
    t.text     "time_reqs"
    t.boolean  "drop_ins"
    t.text     "additional_info"
    t.string   "assigned_room"
    t.integer  "assigned_period"
    t.integer  "cuco_session_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "cuco_sessions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.datetime "start_dt"
    t.datetime "end_dt"
    t.integer  "calendar_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "googleid"
  end

  add_index "events", ["calendar_id"], name: "index_events_on_calendar_id"

  create_table "families", force: :cascade do |t|
    t.string   "name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "primary_adult_id"
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "dob"
    t.integer  "family_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "pronoun_id"
    t.string   "email"
    t.string   "phone"
    t.text     "social_media"
    t.integer  "user_id"
  end

  add_index "people", ["family_id", "created_at"], name: "index_people_on_family_id_and_created_at"
  add_index "people", ["family_id"], name: "index_people_on_family_id"
  add_index "people", ["user_id"], name: "index_people_on_user_id"

  create_table "pronouns", force: :cascade do |t|
    t.string "preferred_pronouns"
  end

  add_index "pronouns", ["preferred_pronouns"], name: "index_pronouns_on_preferred_pronouns", unique: true

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id", null: false
    t.integer "user_id", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "token"
    t.string   "uid"
    t.string   "provider"
    t.integer  "person_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["person_id"], name: "index_users_on_person_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
