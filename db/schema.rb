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

ActiveRecord::Schema.define(version: 2022_01_23_060559) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "choices", force: :cascade do |t|
    t.text "content"
    t.bigint "quiz_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "rhyme_id"
    t.index ["quiz_id"], name: "index_choices_on_quiz_id"
    t.index ["rhyme_id"], name: "index_choices_on_rhyme_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.text "commentary"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "created_at"], name: "index_quizzes_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_quizzes_on_user_id"
  end

  create_table "rhymes", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["content"], name: "index_rhymes_on_content", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "profile"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "youtubes", force: :cascade do |t|
    t.string "video_id"
    t.integer "start_time"
    t.bigint "quiz_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["quiz_id"], name: "index_youtubes_on_quiz_id"
    t.index ["video_id", "start_time"], name: "index_youtubes_on_video_id_and_start_time", unique: true
  end

  add_foreign_key "choices", "quizzes"
  add_foreign_key "choices", "rhymes"
  add_foreign_key "quizzes", "users"
  add_foreign_key "youtubes", "quizzes"
end
