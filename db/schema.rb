# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_04_05_200528) do

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
    t.boolean "checked_in"
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
    t.index ["system_id", "player_id"], name: "index_round_aggregates_on_system_id_and_player_id", unique: true
    t.index ["system_id"], name: "index_round_aggregates_on_system_id"
  end

  create_table "round_individuals", id: :serial, force: :cascade do |t|
    t.integer "player_a_id"
    t.integer "player_b_id"
    t.integer "player_a_points"
    t.integer "player_b_points"
    t.bigint "round_id"
    t.index ["player_a_id"], name: "index_round_individuals_on_player_a_id"
    t.index ["player_b_id"], name: "index_round_individuals_on_player_b_id"
    t.index ["round_id"], name: "index_round_individuals_on_round_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "system_id"
    t.integer "round"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "complete"
    t.index ["system_id"], name: "index_rounds_on_system_id"
  end

  create_table "systems", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "max_players"
    t.decimal "cost", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cohort_id"
    t.datetime "start_date"
    t.integer "round_individuals"
    t.integer "current_round"
    t.boolean "event_started"
    t.datetime "end_date"
    t.datetime "registration_open"
    t.datetime "registration_close"
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
  add_foreign_key "round_individuals", "users", column: "player_a_id"
  add_foreign_key "round_individuals", "users", column: "player_b_id"
  add_foreign_key "systems", "cohorts"
end
