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

ActiveRecord::Schema.define(version: 20150605152720) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "instruments", force: :cascade do |t|
    t.string   "prefix"
    t.string   "port"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "maps", force: :cascade do |t|
    t.integer  "variable_id"
    t.integer  "mapable_id"
    t.string   "mapable_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "maps", ["mapable_type", "mapable_id"], name: "index_maps_on_mapable_type_and_mapable_id", using: :btree
  add_index "maps", ["variable_id"], name: "index_maps_on_variable_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.string   "qc"
    t.string   "literal"
    t.integer  "instrument_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "questions", ["instrument_id"], name: "index_questions_on_instrument_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "topics", ["parent_id"], name: "index_topics_on_parent_id", using: :btree

  create_table "variables", force: :cascade do |t|
    t.string   "name"
    t.string   "label"
    t.string   "var_type"
    t.integer  "instrument_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "variables", ["instrument_id"], name: "index_variables_on_instrument_id", using: :btree

  add_foreign_key "maps", "variables"
  add_foreign_key "questions", "instruments"
  add_foreign_key "variables", "instruments"
end
