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

ActiveRecord::Schema.define(version: 20130715192937) do

  create_table "addresses", force: true do |t|
    t.string   "line1"
    t.string   "line2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instructors", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "photo_url"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "instructors", ["email"], name: "index_instructors_on_email", unique: true, using: :btree
  add_index "instructors", ["phone_number"], name: "index_instructors_on_phone_number", unique: true, using: :btree

  create_table "photos", force: true do |t|
    t.string   "url"
    t.integer  "user_id"
    t.binary   "workout_key"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["place_id"], name: "index_photos_on_place_id", using: :btree
  add_index "photos", ["user_id"], name: "index_photos_on_user_id", using: :btree
  add_index "photos", ["workout_key"], name: "index_photos_on_workout_key", using: :btree

  create_table "places", force: true do |t|
    t.string   "name",                              null: false
    t.integer  "address_id"
    t.string   "source"
    t.binary   "source_key"
    t.string   "url"
    t.string   "category"
    t.string   "phone_number"
    t.text     "tapfit_description"
    t.text     "source_description"
    t.boolean  "is_public",          default: true, null: false
    t.boolean  "can_dropin",         default: true, null: false
    t.float    "dropin_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "icon_photo_id"
    t.integer  "cover_photo_id"
  end

  add_index "places", ["can_dropin"], name: "index_places_on_can_dropin", using: :btree
  add_index "places", ["category"], name: "index_places_on_category", using: :btree
  add_index "places", ["is_public"], name: "index_places_on_is_public", using: :btree
  add_index "places", ["source"], name: "index_places_on_source", using: :btree
  add_index "places", ["source_key"], name: "index_places_on_source_key", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "users", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "workouts", force: true do |t|
    t.string   "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "instructor_id"
    t.integer  "place_id"
    t.text     "source_description"
    t.binary   "workout_key"
    t.string   "source"
    t.boolean  "is_bookable",        default: true
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "workouts", ["end_time"], name: "index_workouts_on_end_time", using: :btree
  add_index "workouts", ["instructor_id"], name: "index_workouts_on_instructor_id", using: :btree
  add_index "workouts", ["is_bookable"], name: "index_workouts_on_is_bookable", using: :btree
  add_index "workouts", ["place_id"], name: "index_workouts_on_place_id", using: :btree
  add_index "workouts", ["source"], name: "index_workouts_on_source", using: :btree
  add_index "workouts", ["start_time"], name: "index_workouts_on_start_time", using: :btree
  add_index "workouts", ["workout_key"], name: "index_workouts_on_workout_key", using: :btree

end
