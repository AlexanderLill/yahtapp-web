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

ActiveRecord::Schema.define(version: 2021_06_22_123549) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "experience_sample_configs", force: :cascade do |t|
    t.string "title", null: false
    t.string "prompt", null: false
    t.integer "scale_steps"
    t.string "scale_label_start"
    t.string "scale_label_center"
    t.string "scale_label_end"
    t.string "schedule", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_experience_sample_configs_on_user_id"
  end

  create_table "goals", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "is_template", default: false
    t.bigint "template_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "color", default: 0
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_goals_on_deleted_at"
    t.index ["template_id"], name: "index_goals_on_template_id"
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "habit_configs", force: :cascade do |t|
    t.bigint "habit_id", null: false
    t.string "schedule"
    t.integer "duration"
    t.boolean "is_skippable"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["habit_id"], name: "index_habit_configs_on_habit_id"
  end

  create_table "habit_reflections", force: :cascade do |t|
    t.bigint "reflection_id", null: false
    t.bigint "habit_id", null: false
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["habit_id"], name: "index_habit_reflections_on_habit_id"
    t.index ["reflection_id"], name: "index_habit_reflections_on_reflection_id"
  end

  create_table "habits", force: :cascade do |t|
    t.bigint "goal_id", null: false
    t.bigint "user_id", null: false
    t.boolean "is_template"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "current_config_id"
    t.integer "template_id"
    t.text "description"
    t.string "title"
    t.datetime "deleted_at"
    t.index ["current_config_id"], name: "index_habits_on_current_config_id"
    t.index ["deleted_at"], name: "index_habits_on_deleted_at"
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

  create_table "reflections", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_reflections_on_user_id"
  end

  create_table "samplings", force: :cascade do |t|
    t.bigint "experience_sample_config_id", null: false
    t.integer "value"
    t.datetime "scheduled_at", null: false
    t.datetime "sampled_at"
    t.datetime "skipped_at"
    t.index ["experience_sample_config_id"], name: "index_samplings_on_experience_sample_config_id"
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
    t.string "reflection_on"
    t.string "reflection_at"
    t.boolean "study_agreement"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "experience_sample_configs", "users"
  add_foreign_key "goals", "goals", column: "template_id"
  add_foreign_key "goals", "users"
  add_foreign_key "habit_configs", "habits"
  add_foreign_key "habit_reflections", "habits"
  add_foreign_key "habit_reflections", "reflections"
  add_foreign_key "habits", "goals"
  add_foreign_key "habits", "habit_configs", column: "current_config_id"
  add_foreign_key "habits", "users"
  add_foreign_key "occurrences", "habits"
  add_foreign_key "reflections", "users"
  add_foreign_key "samplings", "experience_sample_configs"
end
