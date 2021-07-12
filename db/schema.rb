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

ActiveRecord::Schema.define(version: 2021_07_12_131557) do

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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "goal_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_experience_sample_configs_on_deleted_at"
  end

  create_table "goals", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "is_template", default: false
    t.bigint "template_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "color", default: 0
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_goals_on_deleted_at"
  end

  create_table "habit_configs", force: :cascade do |t|
    t.bigint "habit_id", null: false
    t.string "schedule"
    t.integer "duration"
    t.boolean "is_skippable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_enabled", default: true
  end

  create_table "habit_reflections", force: :cascade do |t|
    t.bigint "reflection_id", null: false
    t.bigint "habit_id", null: false
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "habits", force: :cascade do |t|
    t.bigint "goal_id", null: false
    t.bigint "user_id", null: false
    t.boolean "is_template"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "current_config_id"
    t.integer "template_id"
    t.text "description"
    t.string "title"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_habits_on_deleted_at"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
  end

  create_table "occurrences", force: :cascade do |t|
    t.bigint "habit_id", null: false
    t.datetime "scheduled_at", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "skipped_at"
  end

  create_table "reflections", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "samplings", force: :cascade do |t|
    t.bigint "experience_sample_config_id", null: false
    t.integer "value"
    t.datetime "scheduled_at", null: false
    t.datetime "sampled_at"
    t.datetime "skipped_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.integer "role", default: 0
    t.string "timezone", default: "Zurich", null: false
    t.string "reflection_on"
    t.string "reflection_at"
    t.boolean "study_agreement"
  end

  add_foreign_key "experience_sample_configs", "users", name: "experience_sample_configs_user_id_fkey"
  add_foreign_key "goals", "goals", column: "template_id", name: "goals_template_id_fkey"
  add_foreign_key "goals", "users", name: "goals_user_id_fkey"
  add_foreign_key "habit_configs", "habits", name: "habit_configs_habit_id_fkey"
  add_foreign_key "habit_reflections", "habits", name: "habit_reflections_habit_id_fkey"
  add_foreign_key "habit_reflections", "reflections", name: "habit_reflections_reflection_id_fkey"
  add_foreign_key "habits", "goals", name: "habits_goal_id_fkey"
  add_foreign_key "habits", "habit_configs", column: "current_config_id", name: "habits_current_config_id_fkey"
  add_foreign_key "habits", "users", name: "habits_user_id_fkey"
  add_foreign_key "occurrences", "habits", name: "occurrences_habit_id_fkey"
  add_foreign_key "reflections", "users", name: "reflections_user_id_fkey"
  add_foreign_key "samplings", "experience_sample_configs", name: "samplings_experience_sample_config_id_fkey"
end
