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

ActiveRecord::Schema[7.0].define(version: 2022_06_02_081821) do
  create_table "accounts", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "provider"
    t.string "doorkeeper_access_token"
    t.string "doorkeeper_refresh_token"
    t.string "name", default: "", null: false
    t.string "public_id", default: "", null: false
    t.string "role", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "product_type", null: false
    t.string "product_public_id", null: false
    t.string "transaction_type", null: false
    t.integer "price_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "account_id", null: false
    t.string "transaction_type", null: false
    t.string "amount_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["product_id"], name: "index_transactions_on_product_id"
  end

end
