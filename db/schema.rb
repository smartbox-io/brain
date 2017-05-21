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

ActiveRecord::Schema.define(version: 20170521164818) do

  create_table "cell_tags", force: :cascade do |t|
    t.integer "cell_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cell_id"], name: "index_cell_tags_on_cell_id"
    t.index ["tag_id"], name: "index_cell_tags_on_tag_id"
  end

  create_table "cells", force: :cascade do |t|
    t.string "uuid"
    t.string "fqdn"
    t.integer "total_capacity"
    t.integer "available_capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_cells_on_uuid"
  end

  create_table "download_tokens", force: :cascade do |t|
    t.string "token"
    t.integer "full_object_id"
    t.integer "user_id"
    t.integer "cell_id"
    t.string "remote_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cell_id"], name: "index_download_tokens_on_cell_id"
    t.index ["full_object_id"], name: "index_download_tokens_on_full_object_id"
    t.index ["token"], name: "index_download_tokens_on_token"
    t.index ["user_id"], name: "index_download_tokens_on_user_id"
  end

  create_table "full_object_replicas", force: :cascade do |t|
    t.integer "full_object_id"
    t.integer "cell_id"
    t.integer "status"
    t.boolean "is_backup"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cell_id"], name: "index_full_object_replicas_on_cell_id"
    t.index ["full_object_id"], name: "index_full_object_replicas_on_full_object_id"
    t.index ["status"], name: "index_full_object_replicas_on_status"
  end

  create_table "full_object_tags", force: :cascade do |t|
    t.integer "full_object_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["full_object_id"], name: "index_full_object_tags_on_full_object_id"
    t.index ["tag_id"], name: "index_full_object_tags_on_tag_id"
  end

  create_table "full_objects", force: :cascade do |t|
    t.integer "user_id"
    t.string "uuid"
    t.integer "size"
    t.string "name"
    t.integer "backup_size"
    t.integer "replica_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_full_objects_on_user_id"
    t.index ["uuid"], name: "index_full_objects_on_uuid"
  end

  create_table "sync_tokens", force: :cascade do |t|
    t.string "token"
    t.integer "source_cell_id"
    t.integer "target_cell_id"
    t.integer "full_object_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["full_object_id"], name: "index_sync_tokens_on_full_object_id"
    t.index ["source_cell_id"], name: "index_sync_tokens_on_source_cell_id"
    t.index ["status"], name: "index_sync_tokens_on_status"
    t.index ["target_cell_id"], name: "index_sync_tokens_on_target_cell_id"
    t.index ["token"], name: "index_sync_tokens_on_token"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.boolean "visible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["visible"], name: "index_tags_on_visible"
  end

  create_table "upload_tokens", force: :cascade do |t|
    t.string "token"
    t.integer "user_id"
    t.integer "cell_id"
    t.string "remote_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cell_id"], name: "index_upload_tokens_on_cell_id"
    t.index ["token"], name: "index_upload_tokens_on_token"
    t.index ["user_id"], name: "index_upload_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

end
