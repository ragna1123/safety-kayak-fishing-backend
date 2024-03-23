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

ActiveRecord::Schema[7.1].define(version: 2024_03_23_161000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "emergency_contacts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.string "relationship", null: false
    t.string "phone_number"
    t.string "email", null: false
    t.string "line_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorite_locations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "location_id", null: false
    t.string "location_name", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text "title", null: false
    t.text "comment", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tide_data", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.datetime "time", null: false
    t.string "tide_type", null: false
    t.float "height", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_tide_data_on_location_id"
  end

  create_table "trip_tides", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.bigint "tide_data_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tide_data_id"], name: "index_trip_tides_on_tide_data_id"
    t.index ["trip_id"], name: "index_trip_tides_on_trip_id"
  end

  create_table "trip_weathers", force: :cascade do |t|
    t.integer "trip_id", null: false
    t.integer "weather_data_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trips", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "location_id", null: false
    t.datetime "departure_time", null: false
    t.datetime "estimated_return_time", null: false
    t.text "details"
    t.integer "safety_score"
    t.datetime "sunrise_time"
    t.datetime "sunset_time"
    t.datetime "return_time"
    t.text "return_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "profile_image_url", default: ""
    t.string "line_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "weather_data", force: :cascade do |t|
    t.datetime "time", null: false
    t.float "temperature"
    t.float "pressure"
    t.integer "cloud_cover"
    t.float "gust"
    t.integer "humidity"
    t.float "precipitation"
    t.float "swell_direction"
    t.float "swell_height"
    t.float "swell_period"
    t.float "visibility"
    t.float "water_temperature"
    t.float "wave_direction"
    t.float "wave_height"
    t.float "wave_period"
    t.float "wind_wave_direction"
    t.float "wind_wave_height"
    t.float "wind_wave_period"
    t.float "wind_direction"
    t.float "wind_speed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "emergency_contacts", "users", on_delete: :cascade
  add_foreign_key "favorite_locations", "locations", on_delete: :cascade
  add_foreign_key "favorite_locations", "users", on_delete: :cascade
  add_foreign_key "feedbacks", "users"
  add_foreign_key "tide_data", "locations"
  add_foreign_key "trip_tides", "tide_data", column: "tide_data_id"
  add_foreign_key "trip_tides", "trips"
  add_foreign_key "trip_weathers", "trips", on_delete: :cascade
  add_foreign_key "trip_weathers", "weather_data", column: "weather_data_id", on_delete: :cascade
  add_foreign_key "trips", "locations", on_delete: :cascade
  add_foreign_key "trips", "users", on_delete: :cascade
end
