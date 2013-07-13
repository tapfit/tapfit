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

ActiveRecord::Schema.define(version: 20130713195550) do

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

end
