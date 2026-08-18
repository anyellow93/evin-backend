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

ActiveRecord::Schema[7.2].define(version: 2026_08_14_090807) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alumnos", force: :cascade do |t|
    t.string "nombre"
    t.integer "edad"
    t.string "dificultad"
    t.string "curso"
    t.integer "progreso"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_alumnos", force: :cascade do |t|
    t.string "nombre"
    t.integer "edad"
    t.string "dificultad"
    t.integer "progreso"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_juegos", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.string "tipo"
    t.string "img"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_sesiones", force: :cascade do |t|
    t.string "alumno_type", null: false
    t.bigint "alumno_id", null: false
    t.bigint "juego_id", null: false
    t.integer "aciertos"
    t.integer "fallos"
    t.datetime "fecha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alumno_type", "alumno_id"], name: "index_api_sesiones_on_alumno"
    t.index ["juego_id"], name: "index_api_sesiones_on_juego_id"
  end

  create_table "juegos", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.string "nivel"
    t.string "tipo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "img"
  end

  create_table "sesions", force: :cascade do |t|
    t.bigint "alumno_id", null: false
    t.bigint "juego_id", null: false
    t.date "fecha"
    t.integer "aciertos"
    t.integer "intentos"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alumno_id"], name: "index_sesions_on_alumno_id"
    t.index ["juego_id"], name: "index_sesions_on_juego_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "password_digest"
    t.string "rol", default: "profesor"
    t.string "auth_token"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.index ["nombre"], name: "index_users_on_nombre", unique: true
    t.unique_constraint ["auth_token"], name: "users_auth_token_key"
    t.unique_constraint ["email"], name: "users_email_key"
  end

  add_foreign_key "api_sesiones", "juegos"
  add_foreign_key "sesions", "alumnos"
  add_foreign_key "sesions", "juegos"
end
