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

ActiveRecord::Schema[7.2].define(version: 2026_04_29_000001) do
  create_table "alumnos", force: :cascade do |t|
    t.string "nombre"
    t.integer "edad"
    t.string "dificultad"
    t.string "curso"
    t.integer "progreso"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_alumnos_on_user_id"
  end

  create_table "juegos", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.string "img"
    t.string "nivel"
    t.string "tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sesions", force: :cascade do |t|
    t.string "alumno"
    t.string "juego"
    t.date "fecha"
    t.integer "aciertos"
    t.integer "intentos"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "alumno_id"
    t.index ["alumno_id"], name: "index_sesions_on_alumno_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "password_digest"
    t.string "role", default: "profesor"
    t.string "auth_token"
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nombre"], name: "index_users_on_nombre", unique: true
  end

  add_foreign_key "alumnos", "users"
  add_foreign_key "sesions", "alumnos"
end
