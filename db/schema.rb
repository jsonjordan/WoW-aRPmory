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

ActiveRecord::Schema.define(version: 2022_05_21_191429) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "character_images", force: :cascade do |t|
    t.string "catagory"
    t.string "title"
    t.string "url"
    t.string "status"
    t.bigint "character_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "inset"
    t.string "avatar"
    t.string "main"
    t.string "main_raw"
    t.index ["catagory"], name: "index_character_images_on_catagory"
    t.index ["character_id"], name: "index_character_images_on_character_id"
    t.index ["status"], name: "index_character_images_on_status"
  end

  create_table "characters", force: :cascade do |t|
    t.integer "uid"
    t.string "name"
    t.string "title"
    t.string "klass"
    t.string "spec"
    t.string "race"
    t.string "gender"
    t.string "faction"
    t.integer "level"
    t.bigint "money"
    t.json "converted_money"
    t.integer "health"
    t.integer "strength"
    t.integer "intelligence"
    t.integer "wisdom"
    t.integer "constitution"
    t.integer "dexterity"
    t.integer "charisma"
    t.integer "armor_class"
    t.integer "total_deaths"
    t.string "partner_type"
    t.integer "partner_id"
    t.string "remote_inset_url"
    t.string "remote_avatar_url"
    t.string "remote_main_url"
    t.string "remote_main_raw_url"
    t.string "status"
    t.bigint "guild_id"
    t.bigint "user_id"
    t.bigint "realm_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["guild_id"], name: "index_characters_on_guild_id"
    t.index ["realm_id"], name: "index_characters_on_realm_id"
    t.index ["status"], name: "index_characters_on_status"
    t.index ["uid"], name: "index_characters_on_uid"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "guilds", force: :cascade do |t|
    t.integer "uid"
    t.string "name"
    t.string "realm"
    t.string "faction"
    t.string "crest_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_guilds_on_name"
    t.index ["uid"], name: "index_guilds_on_uid"
  end

  create_table "realms", force: :cascade do |t|
    t.string "name"
    t.integer "uid"
    t.string "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.string "uid", null: false
    t.string "battletag", null: false
    t.json "bnet_hash"
    t.string "token"
    t.datetime "token_expiry"
    t.index ["battletag"], name: "index_users_on_battletag", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "character_images", "characters"
  add_foreign_key "characters", "guilds"
  add_foreign_key "characters", "realms"
  add_foreign_key "characters", "users"
end
