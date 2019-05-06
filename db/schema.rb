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

ActiveRecord::Schema.define(version: 2019_05_06_222049) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", id: :serial, force: :cascade do |t|
    t.string "url"
    t.integer "system_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["system_id"], name: "index_attachments_on_system_id"
  end

  create_table "cohorts", id: :serial, force: :cascade do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.string "descriptive_date"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_url"
    t.integer "user_id"
    t.string "name"
    t.string "body"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.string "paypal_client_id"
    t.string "paypal_client_secret"
    t.index ["user_id"], name: "index_cohorts_on_user_id"
  end

  create_table "registrants", id: :serial, force: :cascade do |t|
    t.boolean "paid"
    t.integer "system_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.string "payment_id"
    t.bigint "user_id"
    t.index ["system_id"], name: "index_registrants_on_system_id"
    t.index ["user_id"], name: "index_registrants_on_user_id"
  end

  create_table "round_aggregates", id: :serial, force: :cascade do |t|
    t.integer "player_id"
    t.integer "system_id"
    t.integer "wins"
    t.integer "losses"
    t.integer "draws"
    t.integer "total_points"
    t.integer "opponents", array: true
    t.boolean "withdrawn"
    t.index ["player_id"], name: "index_round_aggregates_on_player_id"
    t.index ["system_id"], name: "index_round_aggregates_on_system_id"
  end

  create_table "round_individuals", id: :serial, force: :cascade do |t|
    t.integer "player_id"
    t.integer "opponent_id"
    t.integer "system_id"
    t.integer "round"
    t.integer "points"
    t.boolean "win"
    t.boolean "loss"
    t.boolean "draw"
    t.index ["opponent_id"], name: "index_round_individuals_on_opponent_id"
    t.index ["player_id"], name: "index_round_individuals_on_player_id"
    t.index ["system_id"], name: "index_round_individuals_on_system_id"
  end

  create_table "systems", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "descriptive_date"
    t.string "description"
    t.integer "max_players"
    t.decimal "cost", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cohort_id"
    t.datetime "start_date"
    t.integer "rounds"
    t.integer "current_round"
    t.boolean "event_started"
    t.index ["cohort_id"], name: "index_systems_on_cohort_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attachments", "systems"
  add_foreign_key "cohorts", "users"
  add_foreign_key "round_aggregates", "users", column: "player_id"
  add_foreign_key "round_individuals", "users", column: "opponent_id"
  add_foreign_key "round_individuals", "users", column: "player_id"
  add_foreign_key "systems", "cohorts"
end
