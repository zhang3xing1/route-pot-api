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

ActiveRecord::Schema.define(version: 20151011103538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "parsed_gps_traces", force: :cascade do |t|
    t.date     "delivery_date"
    t.string   "worker_id"
    t.string   "seq_id"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "zipcode"
    t.datetime "delivered_at"
    t.string   "invoicenumber"
    t.integer  "box_length"
    t.integer  "box_width"
    t.integer  "box_height"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "parsed_gps_traces", ["seq_id"], name: "index_parsed_gps_traces_on_seq_id", using: :btree
  add_index "parsed_gps_traces", ["zipcode"], name: "index_parsed_gps_traces_on_zipcode", using: :btree

  create_table "territories", force: :cascade do |t|
    t.string   "name"
    t.jsonb    "zips",       default: {}
    t.jsonb    "zones",      default: {}
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "territories", ["name"], name: "index_territories_on_name", using: :btree

  create_table "zones", force: :cascade do |t|
    t.string   "name",                                             null: false
    t.geometry "polygon",    limit: {:srid=>0, :type=>"geometry"}
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

end