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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 2021_01_04_090042) do
=======
ActiveRecord::Schema.define(version: 2021_01_04_133211) do
>>>>>>> 240d63dde7728acaa44ba7194530045c09c8a98c

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

<<<<<<< HEAD
=======
  create_table "project_users", force: :cascade do |t|
    t.bigint "users_id"
    t.string "role"
    t.bigint "projects_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["projects_id"], name: "index_project_users_on_projects_id"
    t.index ["users_id"], name: "index_project_users_on_users_id"
  end

>>>>>>> 240d63dde7728acaa44ba7194530045c09c8a98c
  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "color"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

<<<<<<< HEAD
=======
  create_table "task_lists", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.date "date_start"
    t.date "date_end"
    t.string "status"
    t.string "description"
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.bigint "task_list_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_tasks_on_project_id"
    t.index ["task_list_id"], name: "index_tasks_on_task_list_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

>>>>>>> 240d63dde7728acaa44ba7194530045c09c8a98c
  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "username", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "tasks", "projects"
  add_foreign_key "tasks", "task_lists"
  add_foreign_key "tasks", "users"
end
