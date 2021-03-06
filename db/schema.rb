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

ActiveRecord::Schema.define(version: 20150915115331) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "instruments", force: :cascade do |t|
    t.string   "prefix"
    t.string   "port"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "study"
  end

  create_table "links", force: :cascade do |t|
    t.integer  "topic_id"
    t.string   "target_type"
    t.integer  "target_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["target_type", "target_id"], name: "index_links_on_target_type_and_target_id", using: :btree
    t.index ["topic_id"], name: "index_links_on_topic_id", using: :btree
  end

  create_table "maps", force: :cascade do |t|
    t.integer  "variable_id"
    t.string   "mapable_type"
    t.integer  "mapable_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "x"
    t.integer  "y"
    t.index ["mapable_type", "mapable_id"], name: "index_maps_on_mapable_type_and_mapable_id", using: :btree
    t.index ["variable_id"], name: "index_maps_on_variable_id", using: :btree
  end

  create_table "questions", force: :cascade do |t|
    t.string   "qc"
    t.string   "literal"
    t.integer  "instrument_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "parent_id"
    t.integer  "max_x"
    t.integer  "max_y"
    t.index ["instrument_id"], name: "index_questions_on_instrument_id", using: :btree
    t.index ["parent_id"], name: "index_questions_on_parent_id", using: :btree
    t.index ["qc", "instrument_id"], name: "index_questions_on_qc_and_instrument_id", unique: true, using: :btree
  end

  create_table "sequences", force: :cascade do |t|
    t.string   "name"
    t.integer  "instrument_id"
    t.integer  "parent_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "URN"
    t.index ["URN"], name: "index_sequences_on_URN", unique: true, using: :btree
    t.index ["instrument_id"], name: "index_sequences_on_instrument_id", using: :btree
    t.index ["name", "instrument_id"], name: "index_sequences_on_name_and_instrument_id", unique: true, using: :btree
    t.index ["parent_id"], name: "index_sequences_on_parent_id", using: :btree
  end

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "colectica_code"
    t.index ["parent_id"], name: "index_topics_on_parent_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "study"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "variables", force: :cascade do |t|
    t.string   "name"
    t.string   "label"
    t.string   "var_type"
    t.integer  "instrument_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["instrument_id"], name: "index_variables_on_instrument_id", using: :btree
    t.index ["name", "instrument_id"], name: "index_variables_on_name_and_instrument_id", unique: true, using: :btree
  end

  add_foreign_key "links", "topics"
  add_foreign_key "maps", "variables"
  add_foreign_key "questions", "instruments"
  add_foreign_key "sequences", "instruments"
  add_foreign_key "variables", "instruments"
end
