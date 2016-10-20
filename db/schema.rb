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

ActiveRecord::Schema.define(version: 20161020210810) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_signups", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "course_signups", ["course_id"], name: "index_course_signups_on_course_id", using: :btree
  add_index "course_signups", ["person_id"], name: "index_course_signups_on_person_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "short_name"
    t.text     "description"
    t.integer  "min_age"
    t.integer  "max_age"
    t.boolean  "age_firm"
    t.integer  "min_students"
    t.integer  "max_students"
    t.text     "supplies"
    t.text     "room_reqs"
    t.text     "time_reqs"
    t.boolean  "drop_ins"
    t.text     "additional_info"
    t.integer  "period_id"
    t.integer  "cuco_session_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "room_id"
    t.integer  "fee"
  end

  add_index "courses", ["cuco_session_id"], name: "index_courses_on_cuco_session_id", using: :btree
  add_index "courses", ["period_id"], name: "index_courses_on_period_id", using: :btree
  add_index "courses", ["room_id"], name: "index_courses_on_room_id", using: :btree

  create_table "cuco_sessions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "start_date"
    t.date     "end_date"
  end

  create_table "dates", force: :cascade do |t|
    t.integer "cuco_session_id"
  end

  add_index "dates", ["cuco_session_id"], name: "index_dates_on_cuco_session_id", using: :btree

  create_table "event_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "display_name"
    t.integer  "start_date_offset"
    t.time     "start_time"
    t.integer  "end_date_offset"
    t.time     "end_time"
    t.boolean  "members_only"
    t.boolean  "registration"
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "start_dt"
    t.datetime "end_dt"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "dates_id"
    t.integer  "event_type_id"
  end

  add_index "events", ["dates_id"], name: "index_events_on_dates_id", using: :btree
  add_index "events", ["event_type_id"], name: "index_events_on_event_type_id", using: :btree

  create_table "families", force: :cascade do |t|
    t.string   "name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "primary_adult_id"
    t.string   "ec_first_name"
    t.string   "ec_last_name"
    t.string   "ec_phone"
    t.boolean  "ec_text"
    t.string   "ec_relationship"
  end

  add_index "families", ["primary_adult_id"], name: "index_families_on_primary_adult_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "family_id"
    t.integer  "cuco_session_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "memberships", ["cuco_session_id"], name: "index_memberships_on_cuco_session_id", using: :btree
  add_index "memberships", ["family_id"], name: "index_memberships_on_family_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "dob"
    t.integer  "family_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "pronoun_id"
    t.text     "social_media"
  end

  add_index "people", ["family_id", "created_at"], name: "index_people_on_family_id_and_created_at", using: :btree
  add_index "people", ["family_id"], name: "index_people_on_family_id", using: :btree
  add_index "people", ["pronoun_id"], name: "index_people_on_pronoun_id", using: :btree

  create_table "periods", force: :cascade do |t|
    t.string   "name"
    t.time     "start_time"
    t.time     "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pronouns", force: :cascade do |t|
    t.string "preferred_pronouns"
  end

  add_index "pronouns", ["preferred_pronouns"], name: "index_pronouns_on_preferred_pronouns", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id", null: false
    t.integer "user_id", null: false
  end

  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id", using: :btree
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id", using: :btree

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.boolean  "notification_list"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["person_id"], name: "index_users_on_person_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "course_signups", "courses"
  add_foreign_key "course_signups", "people"
  add_foreign_key "courses", "cuco_sessions"
  add_foreign_key "courses", "periods"
  add_foreign_key "courses", "rooms"
  add_foreign_key "dates", "cuco_sessions"
  add_foreign_key "events", "dates"
  add_foreign_key "events", "event_types"
  add_foreign_key "memberships", "cuco_sessions"
  add_foreign_key "memberships", "families"
  add_foreign_key "people", "families"
  add_foreign_key "people", "pronouns"
  add_foreign_key "roles_users", "roles"
  add_foreign_key "roles_users", "users"
end
