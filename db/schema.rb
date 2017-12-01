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

ActiveRecord::Schema.define(version: 20171119111819) do

  create_table "admins", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.boolean "inactive", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email"
    t.index ["inactive"], name: "index_admins_on_inactive"
    t.index ["username"], name: "index_admins_on_username", unique: true
  end

  create_table "cell_block_devices", force: :cascade do |t|
    t.integer "cell_id"
    t.string "device"
    t.integer "total_capacity", limit: 8
    t.integer "available_capacity", limit: 8
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cell_id", "device"], name: "index_cell_block_devices_on_cell_id_and_device", unique: true
    t.index ["cell_id"], name: "index_cell_block_devices_on_cell_id"
  end

  create_table "cell_tags", force: :cascade do |t|
    t.integer "cell_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cell_id"], name: "index_cell_tags_on_cell_id"
    t.index ["tag_id"], name: "index_cell_tags_on_tag_id"
  end

  create_table "cell_volumes", force: :cascade do |t|
    t.integer "cell_block_device_id"
    t.string "partition"
    t.integer "total_capacity", limit: 8
    t.integer "available_capacity", limit: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cell_block_device_id", "partition"], name: "index_cell_volumes_on_cell_block_device_id_and_partition", unique: true
    t.index ["cell_block_device_id"], name: "index_cell_volumes_on_cell_block_device_id"
  end

  create_table "cells", force: :cascade do |t|
    t.string "uuid"
    t.string "fqdn"
    t.string "ip_address"
    t.string "public_ip_address"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_cells_on_uuid", unique: true
  end

  create_table "download_tokens", force: :cascade do |t|
    t.string "token"
    t.integer "full_object_id"
    t.integer "user_id"
    t.integer "cell_volume_id"
    t.string "remote_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cell_volume_id"], name: "index_download_tokens_on_cell_volume_id"
    t.index ["full_object_id"], name: "index_download_tokens_on_full_object_id"
    t.index ["token"], name: "index_download_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_download_tokens_on_user_id"
  end

  create_table "full_object_replicas", force: :cascade do |t|
    t.integer "full_object_id"
    t.integer "cell_volume_id"
    t.integer "status"
    t.boolean "is_backup", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cell_volume_id"], name: "index_full_object_replicas_on_cell_volume_id"
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
    t.string "name"
    t.integer "size"
    t.string "md5sum"
    t.string "sha1sum"
    t.string "sha256sum"
    t.integer "backup_size"
    t.integer "replica_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_full_objects_on_user_id"
    t.index ["uuid"], name: "index_full_objects_on_uuid"
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.integer "user_id"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_refresh_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "sync_tokens", force: :cascade do |t|
    t.string "token"
    t.integer "source_cell_volume_id"
    t.integer "target_cell_volume_id"
    t.integer "full_object_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["full_object_id"], name: "index_sync_tokens_on_full_object_id"
    t.index ["source_cell_volume_id"], name: "index_sync_tokens_on_source_cell_volume_id"
    t.index ["status"], name: "index_sync_tokens_on_status"
    t.index ["target_cell_volume_id"], name: "index_sync_tokens_on_target_cell_volume_id"
    t.index ["token"], name: "index_sync_tokens_on_token", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["visible"], name: "index_tags_on_visible"
  end

  create_table "upload_tokens", force: :cascade do |t|
    t.string "token"
    t.integer "user_id"
    t.integer "cell_volume_id"
    t.string "remote_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cell_volume_id"], name: "index_upload_tokens_on_cell_volume_id"
    t.index ["token"], name: "index_upload_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_upload_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.integer "upload_rate_limit"
    t.integer "download_rate_limit"
    t.boolean "inactive", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["inactive"], name: "index_users_on_inactive"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
