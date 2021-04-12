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

ActiveRecord::Schema.define(version: 2021_04_12_212436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "goals", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "is_template", default: false
    t.bigint "template_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["template_id"], name: "index_goals_on_template_id"
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "habits", force: :cascade do |t|
    t.string "title"
    t.bigint "goal_id", null: false
    t.bigint "user_id", null: false
    t.string "schedule"
    t.integer "duration"
    t.boolean "is_template"
    t.boolean "is_skippable"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["goal_id"], name: "index_habits_on_goal_id"
    t.index ["user_id"], name: "index_habits_on_user_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "occurrences", force: :cascade do |t|
    t.bigint "habit_id", null: false
    t.datetime "scheduled_at", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "skipped_at"
    t.index ["habit_id"], name: "index_occurrences_on_habit_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.integer "role", default: 0
    t.string "timezone", default: "Zurich", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "goals", "goals", column: "template_id"
  add_foreign_key "goals", "users"
  add_foreign_key "habits", "goals"
  add_foreign_key "habits", "users"
  add_foreign_key "occurrences", "habits"
end
