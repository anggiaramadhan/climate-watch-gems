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

ActiveRecord::Schema.define(version: 2018_10_24_100559) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "datasets", force: :cascade do |t|
    t.string "name"
    t.bigint "section_id"
    t.index ["section_id", "name"], name: "datasets_section_id_name_key", unique: true
    t.index ["section_id"], name: "index_datasets_on_section_id"
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "platforms_name_key", unique: true
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.bigint "platform_id"
    t.index ["platform_id", "name"], name: "sections_platform_id_name_key", unique: true
    t.index ["platform_id"], name: "index_sections_on_platform_id"
  end

  create_table "worker_logs", force: :cascade do |t|
    t.integer "state"
    t.string "jid"
    t.bigint "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "error"
    t.index ["jid"], name: "index_worker_logs_on_jid"
    t.index ["section_id"], name: "index_worker_logs_on_section_id"
  end

  add_foreign_key "datasets", "sections"
  add_foreign_key "sections", "platforms"
  add_foreign_key "worker_logs", "sections"
end
