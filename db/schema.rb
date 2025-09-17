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

ActiveRecord::Schema[8.0].define(version: 2025_09_17_151724) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accommodations", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.string "name"
    t.string "accommodation_type"
    t.text "address"
    t.text "contact_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_cost"
    t.date "check_in_date"
    t.date "check_out_date"
    t.text "description"
    t.index ["trip_id"], name: "index_accommodations_on_trip_id"
  end

  create_table "betting_participations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "betting_pool_id", null: false
    t.datetime "joined_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["betting_pool_id"], name: "index_betting_participations_on_betting_pool_id"
    t.index ["user_id"], name: "index_betting_participations_on_user_id"
  end

  create_table "betting_pools", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.string "name"
    t.decimal "cost_per_person"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "entry_fee"
    t.string "pool_type"
    t.boolean "active"
    t.index ["trip_id"], name: "index_betting_pools_on_trip_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.integer "par"
    t.integer "yardage"
    t.decimal "rating"
    t.integer "slope"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "golf_rounds", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.string "course_name"
    t.decimal "cost_per_person"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_id"
    t.text "description"
    t.datetime "tee_time"
    t.index ["course_id"], name: "index_golf_rounds_on_course_id"
    t.index ["trip_id"], name: "index_golf_rounds_on_trip_id"
  end

  create_table "itinerary_items", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.date "date"
    t.string "activity_type"
    t.string "title"
    t.text "description"
    t.string "location"
    t.time "start_time"
    t.time "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_itinerary_items_on_trip_id"
  end

  create_table "room_reservations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.datetime "reservation_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_room_reservations_on_room_id"
    t.index ["user_id"], name: "index_room_reservations_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "accommodation_id", null: false
    t.string "name"
    t.string "room_type"
    t.integer "capacity"
    t.decimal "cost_per_person"
    t.text "beds_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "room_number"
    t.text "description"
    t.index ["accommodation_id"], name: "index_rooms_on_accommodation_id"
  end

  create_table "trip_registrations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "trip_id", null: false
    t.datetime "registration_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deposit_paid", default: false, null: false
    t.datetime "deposit_paid_date"
    t.integer "deposit_confirmed_by_id"
    t.index ["deposit_confirmed_by_id"], name: "index_trip_registrations_on_deposit_confirmed_by_id"
    t.index ["trip_id"], name: "index_trip_registrations_on_trip_id"
    t.index ["user_id"], name: "index_trip_registrations_on_user_id"
  end

  create_table "trips", force: :cascade do |t|
    t.string "name", null: false
    t.string "location", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.decimal "total_cost", precision: 10, scale: 2, null: false
    t.text "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "deposit_amount", precision: 10, scale: 2, default: "0.0"
    t.index ["active"], name: "index_trips_on_active"
    t.index ["start_date"], name: "index_trips_on_start_date"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.decimal "handicap", precision: 4, scale: 1
    t.string "password_digest", null: false
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "accommodations", "trips"
  add_foreign_key "betting_participations", "betting_pools"
  add_foreign_key "betting_participations", "users"
  add_foreign_key "betting_pools", "trips"
  add_foreign_key "golf_rounds", "courses"
  add_foreign_key "golf_rounds", "trips"
  add_foreign_key "itinerary_items", "trips"
  add_foreign_key "room_reservations", "rooms"
  add_foreign_key "room_reservations", "users"
  add_foreign_key "rooms", "accommodations"
  add_foreign_key "trip_registrations", "trips"
  add_foreign_key "trip_registrations", "users"
  add_foreign_key "trip_registrations", "users", column: "deposit_confirmed_by_id"
end
