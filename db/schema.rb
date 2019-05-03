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

ActiveRecord::Schema.define(version: 2019_04_28_181243) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "areas", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "location", null: false
    t.integer "specialty", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "doctors", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "specialty", null: false
    t.integer "years_experience", null: false
    t.decimal "salary", precision: 64, scale: 12, null: false
    t.uuid "domain_id"
    t.uuid "area_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_doctors_on_area_id"
    t.index ["domain_id"], name: "index_doctors_on_domain_id"
  end

  create_table "patients", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "insurancePlan", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "firstName", null: false
    t.string "lastName"
    t.string "dob"
    t.string "gender", null: false
    t.string "labor_type", null: false
    t.uuid "labor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["labor_type", "labor_id"], name: "index_people_on_labor_type_and_labor_id"
  end

  create_table "treatments", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "patient_id", null: false
    t.uuid "doctor_id", null: false
    t.integer "duration"
    t.text "medicaments", default: [], array: true
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_treatments_on_doctor_id"
    t.index ["patient_id"], name: "index_treatments_on_patient_id"
  end

end
