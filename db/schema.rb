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

ActiveRecord::Schema.define(version: 2021_06_11_190521) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.bigint "tournament_id", null: false
    t.integer "first_player_id"
    t.integer "second_player_id"
    t.integer "winner_id"
    t.integer "loser_id"
    t.boolean "played"
    t.integer "score"
    t.string "round"
    t.integer "index"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tournament_id"], name: "index_games_on_tournament_id"
  end

  create_table "leagueplayers", force: :cascade do |t|
    t.bigint "league_id", null: false
    t.bigint "user_id", null: false
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["league_id"], name: "index_leagueplayers_on_league_id"
    t.index ["user_id"], name: "index_leagueplayers_on_user_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.string "name"
    t.string "encrypted_password"
    t.boolean "public"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "leagues_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "league_id", null: false
  end

  create_table "pronos", force: :cascade do |t|
    t.bigint "tournament_id", null: false
    t.bigint "leagueplayer_id", null: false
    t.integer "winner_id"
    t.integer "loser_id"
    t.string "round"
    t.integer "index"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "game_id", null: false
    t.boolean "successful"
    t.index ["game_id"], name: "index_pronos_on_game_id"
    t.index ["leagueplayer_id"], name: "index_pronos_on_leagueplayer_id"
    t.index ["tournament_id"], name: "index_pronos_on_tournament_id"
  end

  create_table "scrapps", force: :cascade do |t|
    t.string "tournament_name"
    t.integer "tournament_number"
    t.boolean "drawed"
    t.date "start_date"
    t.date "end_date"
    t.integer "index"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scrapps_tennisplayers", id: false, force: :cascade do |t|
    t.bigint "tennisplayer_id", null: false
    t.bigint "scrapp_id", null: false
  end

  create_table "tennisplayers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "age"
    t.string "handed"
    t.integer "height"
    t.integer "weight"
    t.string "nationality"
    t.integer "atp_rank"
    t.integer "race_rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tennisplayers_tournaments", id: false, force: :cascade do |t|
    t.bigint "tennisplayer_id", null: false
    t.bigint "tournament_id", null: false
  end

  create_table "tournaments", force: :cascade do |t|
    t.bigint "league_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "scrapp_id", null: false
    t.index ["league_id"], name: "index_tournaments_on_league_id"
    t.index ["scrapp_id"], name: "index_tournaments_on_scrapp_id"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "games", "tournaments"
  add_foreign_key "leagueplayers", "leagues"
  add_foreign_key "leagueplayers", "users"
  add_foreign_key "pronos", "games"
  add_foreign_key "pronos", "leagueplayers"
  add_foreign_key "pronos", "tournaments"
  add_foreign_key "tournaments", "leagues"
  add_foreign_key "tournaments", "scrapps"
end
