# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160512220545) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abilities", force: :cascade do |t|
    t.string   "name"
    t.string   "cooldown"
    t.text     "in_game_effect"
    t.text     "flavor_text"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "abilities_character_classes", id: false, force: :cascade do |t|
    t.integer "ability_id",         null: false
    t.integer "character_class_id", null: false
  end

  create_table "campaigns", force: :cascade do |t|
    t.string   "name"
    t.integer  "dm_id"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "campaigns_users", id: false, force: :cascade do |t|
    t.integer "player_campaign_id", null: false
    t.integer "player_id",          null: false
  end

  create_table "character_classes", force: :cascade do |t|
    t.string   "name"
    t.string   "armor_type"
    t.boolean  "prestige"
    t.text     "entry_requirements"
    t.integer  "fortitude_index"
    t.integer  "strength_index"
    t.integer  "mana_index"
    t.integer  "swiftness_index"
    t.integer  "intuition_index"
    t.text     "flavor_text"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "characters", force: :cascade do |t|
    t.string   "name"
    t.integer  "age"
    t.integer  "campaign_id"
    t.integer  "player_id"
    t.integer  "race_id"
    t.integer  "racial_bonus_id"
    t.integer  "fortitude_offset"
    t.integer  "strength_offset"
    t.integer  "mana_offset"
    t.integer  "swiftness_offset"
    t.integer  "intuition_offset"
    t.text     "backstory"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "levels", force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "char_class_id"
    t.integer  "character_level"
    t.integer  "ability_id"
    t.integer  "fortitude_increase"
    t.integer  "strength_increase"
    t.integer  "mana_increase"
    t.integer  "swiftness_increase"
    t.integer  "intuition_increase"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "races", force: :cascade do |t|
    t.string   "name"
    t.string   "singular"
    t.string   "adjective"
    t.integer  "age_of_maturity"
    t.integer  "fortitude_index"
    t.integer  "strength_index"
    t.integer  "mana_index"
    t.integer  "swiftness_index"
    t.integer  "intuition_index"
    t.text     "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "racial_bonuses", force: :cascade do |t|
    t.string   "name"
    t.integer  "race_id"
    t.string   "cooldown"
    t.text     "in_game_effect"
    t.text     "flavor_text"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",            null: false
    t.string   "name"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
