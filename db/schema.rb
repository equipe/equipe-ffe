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

ActiveRecord::Schema[8.1].define(version: 2025_10_26_065159) do
  create_table "clubs", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "ffe_id"
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ffe_id"], name: "index_clubs_on_ffe_id"
  end

  create_table "competitions", force: :cascade do |t|
    t.string "competition_no"
    t.datetime "created_at", precision: nil, null: false
    t.string "discipline"
    t.string "horse_pony", default: "R", null: false
    t.string "judgement_id"
    t.integer "late_entry_fee"
    t.string "name"
    t.integer "profil_detail"
    t.json "result_details"
    t.integer "show_id"
    t.date "starts_on", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["show_id"], name: "index_competitions_on_show_id"
  end

  create_table "entries", force: :cascade do |t|
    t.integer "competition_id"
    t.datetime "created_at", precision: nil, null: false
    t.string "ffe_id", null: false
    t.integer "horse_id"
    t.integer "rider_id"
    t.integer "start_no"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["competition_id"], name: "index_entries_on_competition_id"
    t.index ["ffe_id"], name: "index_entries_on_ffe_id"
    t.index ["horse_id"], name: "index_entries_on_horse_id"
    t.index ["rider_id"], name: "index_entries_on_rider_id"
  end

  create_table "entry_file_uploads", force: :cascade do |t|
    t.text "content"
    t.string "content_hash"
    t.integer "content_size"
    t.datetime "created_at", null: false
    t.string "federation_organizer_id"
    t.string "federation_user_email"
    t.string "federation_user_name"
    t.integer "show_id", null: false
    t.datetime "updated_at", null: false
    t.index ["show_id", "content_hash"], name: "index_entry_file_uploads_on_show_id_and_content_hash", unique: true
    t.index ["show_id"], name: "index_entry_file_uploads_on_show_id"
  end

  create_table "horses", force: :cascade do |t|
    t.integer "born_year"
    t.string "breed"
    t.string "category", default: "H", null: false
    t.string "chip_no"
    t.string "color"
    t.datetime "created_at", precision: nil, null: false
    t.string "dam"
    t.string "dam_sire"
    t.integer "height"
    t.string "licence"
    t.string "name"
    t.string "race"
    t.string "sex"
    t.string "sire"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["licence"], name: "index_horses_on_licence"
  end

  create_table "organizers", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "ffe_id"
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ffe_id"], name: "index_organizers_on_ffe_id"
  end

  create_table "people", force: :cascade do |t|
    t.date "birthday"
    t.integer "club_id"
    t.datetime "created_at", precision: nil, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "licence"
    t.boolean "official", default: false, null: false
    t.integer "region_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["club_id"], name: "index_people_on_club_id"
    t.index ["licence"], name: "index_people_on_licence"
    t.index ["region_id"], name: "index_people_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "ffe_id"
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ffe_id"], name: "index_regions_on_ffe_id"
  end

  create_table "shows", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.date "ends_on"
    t.string "ffe_id"
    t.string "name"
    t.integer "organizer_id"
    t.date "starts_on"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ffe_id"], name: "index_shows_on_ffe_id"
    t.index ["organizer_id"], name: "index_shows_on_organizer_id"
  end

  add_foreign_key "competitions", "shows"
  add_foreign_key "entries", "competitions"
  add_foreign_key "entries", "horses"
  add_foreign_key "entries", "people", column: "rider_id"
  add_foreign_key "entry_file_uploads", "shows"
  add_foreign_key "people", "clubs"
  add_foreign_key "people", "regions"
  add_foreign_key "shows", "organizers"
end
