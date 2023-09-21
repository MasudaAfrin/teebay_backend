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

ActiveRecord::Schema[7.0].define(version: 2023_09_21_040534) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "line_items", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.integer "item_type"
    t.bigint "item_owner_id"
    t.date "rental_time_start"
    t.date "rental_time_end"
    t.decimal "buy_price", default: "0.0"
    t.decimal "rent_price", default: "0.0"
    t.string "rent_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_line_items_on_product_id"
    t.index ["user_id"], name: "index_line_items_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "product_categories", default: [], array: true
    t.decimal "price", precision: 10, scale: 2
    t.string "price_option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "rental_price", default: "0.0"
    t.bigint "created_by"
    t.index ["created_by"], name: "index_products_on_created_by"
  end

  create_table "settings", force: :cascade do |t|
    t.json "app_setting", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "address"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "auth_token"
  end

  add_foreign_key "line_items", "products"
  add_foreign_key "line_items", "users"
end
