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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130314081925) do

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "tool_bom_items", :force => true do |t|
    t.integer  "tool_bom_id"
    t.integer  "tool_part_id"
    t.integer  "quantity"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "tool_bom_items", ["tool_bom_id"], :name => "tool_bom_items_bom_id"
  add_index "tool_bom_items", ["tool_part_id"], :name => "tool_bom_items_part_id"

  create_table "tool_boms", :force => true do |t|
    t.string   "hilt_no",            :default => ""
    t.string   "model",              :default => ""
    t.string   "product_line",       :default => ""
    t.string   "machine_mode",       :default => ""
    t.string   "machine_code",       :default => ""
    t.string   "process_position",   :default => ""
    t.string   "process_hole",       :default => ""
    t.string   "tunning_machine",    :default => ""
    t.string   "tunning_mode",       :default => ""
    t.integer  "tunning_man_hour",   :default => 0
    t.integer  "issue_count",        :default => 0
    t.integer  "grind_count",        :default => 0
    t.boolean  "eng_203_applicable", :default => false
    t.boolean  "eng_201_applicable", :default => false
    t.boolean  "eng_185_applicable", :default => false
    t.boolean  "eng_182_applicable", :default => false
    t.boolean  "eng_181_applicable", :default => false
    t.boolean  "eng_161_applicable", :default => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "tool_boms", ["hilt_no"], :name => "tool_boms_hilt_no"

  create_table "tool_part_items", :force => true do |t|
    t.integer  "tool_part_id"
    t.string   "serial_no"
    t.integer  "quantity"
    t.integer  "accumulated_grinding_time"
    t.integer  "accumulated_processing_quantity"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "tool_part_items", ["serial_no"], :name => "tool_part_items_serial"
  add_index "tool_part_items", ["tool_part_id"], :name => "tool_part_items_part_id"

  create_table "tool_parts", :force => true do |t|
    t.string   "model"
    t.string   "category"
    t.string   "sub_category"
    t.boolean  "standardized"
    t.string   "specification"
    t.integer  "machine_quantity"
    t.integer  "available_quantity"
    t.boolean  "grindable"
    t.integer  "grinding_time"
    t.integer  "processing_quantity"
    t.string   "grinding_machine"
    t.string   "grinding_man_hour"
    t.string   "material_no"
    t.string   "manufacturer"
    t.string   "supplier"
    t.decimal  "unit_price",            :precision => 18, :scale => 2
    t.integer  "min_purchase_quantity"
    t.string   "stock_no"
    t.string   "stack_no"
    t.integer  "stock_current"
    t.integer  "stock_max"
    t.integer  "stock_min"
    t.string   "compansation"
    t.decimal  "scrapping_length",      :precision => 18, :scale => 2
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "tool_parts", ["category"], :name => "tool_parts_cat"
  add_index "tool_parts", ["category"], :name => "tool_parts_sub_cat"
  add_index "tool_parts", ["model"], :name => "tool_parts_model"

  create_table "tunning_diagrams", :force => true do |t|
    t.string   "hilt_no"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "archive_file_name"
    t.string   "archive_content_type"
    t.integer  "archive_file_size"
    t.datetime "archive_updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name",                   :default => ""
    t.string   "emp_no",                 :default => ""
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "work_order_items", :force => true do |t|
    t.integer  "work_order_id"
    t.integer  "tool_part_item_id"
    t.integer  "tool_bom_item_id"
    t.integer  "quantity"
    t.boolean  "grinded",           :default => false
    t.datetime "grinded_at"
    t.integer  "grinded_by_id"
    t.string   "grinding_machine"
    t.integer  "grinding_man_hour"
    t.string   "grinding_mode"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "work_order_items", ["grinded"], :name => "work_order_items_grinded"
  add_index "work_order_items", ["tool_part_item_id"], :name => "work_order_items_tpi_id"
  add_index "work_order_items", ["work_order_id"], :name => "work_order_items_order_id"

  create_table "work_orders", :force => true do |t|
    t.string   "hilt_no"
    t.integer  "tool_bom_id"
    t.datetime "issued_at"
    t.integer  "issued_by_id"
    t.datetime "received_at"
    t.integer  "received_by_id"
    t.datetime "tuned_at"
    t.integer  "tuned_by_id"
    t.boolean  "received",         :default => false
    t.boolean  "tuned",            :default => false
    t.boolean  "grinded",          :default => false
    t.string   "tunning_machine",  :default => ""
    t.string   "tunning_mode",     :default => ""
    t.string   "tunning_man_hour", :default => "0"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "work_orders", ["grinded"], :name => "work_orders_grinded"
  add_index "work_orders", ["received"], :name => "work_orders_received"
  add_index "work_orders", ["tool_bom_id"], :name => "work_orders_bom_id"
  add_index "work_orders", ["tuned"], :name => "work_orders_tuned"

end
