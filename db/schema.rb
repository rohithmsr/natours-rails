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

ActiveRecord::Schema.define(version: 2023_09_02_091756) do

  create_table "journeys", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.integer "tour_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tour_id"], name: "index_journeys_on_tour_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "traveller_id", null: false
    t.integer "journey_id", null: false
    t.decimal "amount", precision: 5, scale: 2
    t.boolean "payment_done", default: false, null: false
    t.string "travel_status", default: "upcoming"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["journey_id"], name: "index_orders_on_journey_id"
    t.index ["traveller_id"], name: "index_orders_on_traveller_id"
  end

  create_table "tours", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "difficulty"
    t.decimal "price", precision: 5, scale: 2
    t.float "price_discount", default: 0.0
    t.text "description"
    t.string "key"
    t.index ["key"], name: "index_tours_on_key", unique: true
    t.index ["name"], name: "index_tours_on_name"
  end

  create_table "travel_assignments", force: :cascade do |t|
    t.integer "traveller_id", null: false
    t.integer "journey_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["journey_id"], name: "index_travel_assignments_on_journey_id"
    t.index ["traveller_id", "journey_id"], name: "index_travel_assignments_on_traveller_id_and_journey_id", unique: true
    t.index ["traveller_id"], name: "index_travel_assignments_on_traveller_id"
  end

  create_table "travellers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "avatar"
    t.string "status"
    t.index ["confirmation_token"], name: "index_travellers_on_confirmation_token", unique: true
    t.index ["email"], name: "index_travellers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_travellers_on_reset_password_token", unique: true
  end

  add_foreign_key "journeys", "tours"
  add_foreign_key "orders", "journeys"
  add_foreign_key "orders", "travellers"
  add_foreign_key "travel_assignments", "journeys"
  add_foreign_key "travel_assignments", "travellers"
end
