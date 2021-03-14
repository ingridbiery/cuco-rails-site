# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_09_032648) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "banners", force: :cascade do |t|
    t.text "banner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "is_worker"
    t.integer "display_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_helper"
  end

  create_table "course_signups", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_role_id"
    t.index ["course_id"], name: "index_course_signups_on_course_id"
    t.index ["course_role_id"], name: "index_course_signups_on_course_role_id"
    t.index ["person_id"], name: "index_course_signups_on_person_id"
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.text "description"
    t.integer "min_age"
    t.integer "max_age"
    t.boolean "age_firm"
    t.integer "min_students"
    t.integer "max_students"
    t.text "supplies"
    t.text "room_reqs"
    t.text "time_reqs"
    t.boolean "drop_ins"
    t.text "additional_info"
    t.integer "period_id"
    t.integer "cuco_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "fee"
    t.integer "created_by_id"
    t.text "signups_to_add"
    t.boolean "is_away", default: false
    t.index ["created_by_id"], name: "index_courses_on_created_by_id"
    t.index ["cuco_session_id"], name: "index_courses_on_cuco_session_id"
    t.index ["period_id"], name: "index_courses_on_period_id"
  end

  create_table "courses_rooms", id: false, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "room_id", null: false
    t.index ["course_id", "room_id"], name: "index_courses_rooms_on_course_id_and_room_id"
    t.index ["room_id", "course_id"], name: "index_courses_rooms_on_room_id_and_course_id"
  end

  create_table "cuco_sessions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_date"
    t.date "end_date"
  end

  create_table "dates", id: :serial, force: :cascade do |t|
    t.integer "cuco_session_id"
    t.index ["cuco_session_id"], name: "index_dates_on_cuco_session_id"
  end

  create_table "event_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "display_name"
    t.integer "start_date_offset"
    t.time "start_time"
    t.integer "end_date_offset"
    t.time "end_time"
    t.boolean "members_only"
    t.boolean "registration"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "start_dt"
    t.datetime "end_dt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dates_id"
    t.integer "event_type_id"
    t.index ["dates_id"], name: "index_events_on_dates_id"
    t.index ["event_type_id"], name: "index_events_on_event_type_id"
  end

  create_table "families", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "street_address"
    t.string "city"
    t.string "state"
    t.integer "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "primary_adult_id"
    t.string "ec_first_name"
    t.string "ec_last_name"
    t.string "ec_phone"
    t.boolean "ec_text"
    t.string "ec_relationship"
    t.string "phone"
    t.boolean "text"
    t.index ["primary_adult_id"], name: "index_families_on_primary_adult_id"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "family_id"
    t.integer "cuco_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notification_params"
    t.string "status"
    t.string "transaction_id"
    t.datetime "purchased_at"
    t.index ["cuco_session_id"], name: "index_memberships_on_cuco_session_id"
    t.index ["family_id"], name: "index_memberships_on_family_id"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.date "dob"
    t.integer "family_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pronoun_id"
    t.text "social_media"
    t.integer "ceramics_number"
    t.index ["family_id", "created_at"], name: "index_people_on_family_id_and_created_at"
    t.index ["family_id"], name: "index_people_on_family_id"
    t.index ["pronoun_id"], name: "index_people_on_pronoun_id"
  end

  create_table "periods", id: :serial, force: :cascade do |t|
    t.string "name"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "required_signup"
  end

  create_table "pronouns", id: :serial, force: :cascade do |t|
    t.string "preferred_pronouns"
    t.index ["preferred_pronouns"], name: "index_pronouns_on_preferred_pronouns", unique: true
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id", null: false
    t.integer "user_id", null: false
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "rooms", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "token"
    t.string "uid"
    t.string "provider"
    t.integer "person_id"
    t.boolean "notification_list"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["person_id"], name: "index_users_on_person_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "course_signups", "course_roles"
  add_foreign_key "course_signups", "courses"
  add_foreign_key "course_signups", "people"
  add_foreign_key "courses", "cuco_sessions"
  add_foreign_key "courses", "periods"
  add_foreign_key "courses", "users", column: "created_by_id"
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
