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

ActiveRecord::Schema.define(version: 2022_01_30_154238) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deputies", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "cpf"
    t.integer "deputy_id"
    t.integer "legislature_id"
    t.string "state", limit: 2
    t.string "political_party"
    t.string "photo_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "expense_types", force: :cascade do |t|
    t.integer "expense_type_id"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.bigint "deputy_id", null: false
    t.bigint "expense_type_id", null: false
    t.bigint "provider_id", null: false
    t.integer "year"
    t.integer "month"
    t.integer "document_code"
    t.string "document_number"
    t.string "document_type"
    t.integer "document_type_id"
    t.date "date"
    t.decimal "value", precision: 10, scale: 2
    t.decimal "net_value", precision: 10, scale: 2
    t.decimal "gloss_value", precision: 10, scale: 2
    t.string "document_url"
    t.string "refund_number"
    t.integer "batch_code"
    t.integer "tranche"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deputy_id"], name: "index_expenses_on_deputy_id"
    t.index ["expense_type_id"], name: "index_expenses_on_expense_type_id"
    t.index ["provider_id"], name: "index_expenses_on_provider_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "cpf_cnpj"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "expenses", "deputies"
  add_foreign_key "expenses", "expense_types"
  add_foreign_key "expenses", "providers"
end
