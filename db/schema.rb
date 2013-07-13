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

ActiveRecord::Schema.define(version: 20130713163009) do

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
    t.string   "category",                          null: false
    t.string   "phone_number"
    t.text     "tapfit_description"
    t.text     "source_description"
    t.boolean  "is_public",          default: true, null: false
    t.boolean  "can_dropin",         default: true, null: false
    t.float    "dropin_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
