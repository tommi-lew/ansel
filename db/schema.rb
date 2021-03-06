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

ActiveRecord::Schema.define(version: 20160905013309) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "browser_stack_jobs", force: :cascade do |t|
    t.json     "job_params",         default: {}
    t.string   "url_path"
    t.string   "status",             default: "created_locally"
    t.string   "request_id"
    t.json     "result"
    t.integer  "screenshots_job_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "browsers", force: :cascade do |t|
    t.string   "os_version"
    t.string   "browser_version"
    t.string   "os"
    t.string   "device"
    t.string   "browser"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "screenshot_results", force: :cascade do |t|
    t.string   "image_url"
    t.string   "thumbnail_image_url"
    t.json     "data"
    t.integer  "browser_id"
    t.integer  "browser_stack_job_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "screenshots_jobs", force: :cascade do |t|
    t.string   "url_base"
    t.string   "status",      default: "scheduled"
    t.string   "requester"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "browser_ids", default: [],                       array: true
    t.text     "url_paths",   default: [],                       array: true
  end

end
