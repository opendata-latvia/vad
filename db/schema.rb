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

ActiveRecord::Schema.define(:version => 20161030142025) do

  create_table "declaration_cash", :force => true do |t|
    t.integer  "declaration_id"
    t.string   "kind"
    t.decimal  "amount",              :precision => 15, :scale => 2
    t.string   "currency"
    t.decimal  "amount_lvl",          :precision => 15, :scale => 2
    t.string   "amount_in_words"
    t.string   "bank"
    t.string   "registration_number"
    t.string   "legal_address"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.decimal  "amount_eur",          :precision => 15, :scale => 2
  end

  add_index "declaration_cash", ["declaration_id"], :name => "index_declaration_cash_on_declaration_id"

  create_table "declaration_companies", :force => true do |t|
    t.integer  "declaration_id"
    t.string   "name"
    t.string   "registration_number"
    t.string   "legal_address"
    t.integer  "shares"
    t.decimal  "amount",              :precision => 15, :scale => 2
    t.string   "currency"
    t.decimal  "amount_lvl",          :precision => 15, :scale => 2
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.decimal  "amount_eur",          :precision => 15, :scale => 2
  end

  add_index "declaration_companies", ["declaration_id"], :name => "index_declaration_companies_on_declaration_id"

  create_table "declaration_deals", :force => true do |t|
    t.integer  "declaration_id"
    t.string   "description"
    t.decimal  "amount",         :precision => 15, :scale => 2
    t.string   "currency"
    t.decimal  "amount_lvl",     :precision => 15, :scale => 2
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.decimal  "amount_eur",     :precision => 15, :scale => 2
  end

  add_index "declaration_deals", ["declaration_id"], :name => "index_declaration_deals_on_declaration_id"

  create_table "declaration_debts", :force => true do |t|
    t.integer  "declaration_id"
    t.decimal  "amount",          :precision => 15, :scale => 2
    t.string   "currency"
    t.decimal  "amount_lvl",      :precision => 15, :scale => 2
    t.string   "amount_in_words"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.text     "description"
    t.decimal  "amount_eur",      :precision => 15, :scale => 2
  end

  add_index "declaration_debts", ["declaration_id"], :name => "index_declaration_debts_on_declaration_id"

  create_table "declaration_income", :force => true do |t|
    t.integer  "declaration_id"
    t.string   "source"
    t.string   "registration_number"
    t.string   "legal_address"
    t.string   "kind"
    t.decimal  "amount",              :precision => 15, :scale => 2
    t.string   "currency"
    t.decimal  "amount_lvl",          :precision => 15, :scale => 2
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.decimal  "amount_eur",          :precision => 15, :scale => 2
  end

  add_index "declaration_income", ["declaration_id"], :name => "index_declaration_income_on_declaration_id"

  create_table "declaration_loans", :force => true do |t|
    t.integer  "declaration_id"
    t.decimal  "amount",          :precision => 15, :scale => 2
    t.string   "currency"
    t.decimal  "amount_lvl",      :precision => 15, :scale => 2
    t.string   "amount_in_words"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.text     "description"
    t.decimal  "amount_eur",      :precision => 15, :scale => 2
  end

  add_index "declaration_loans", ["declaration_id"], :name => "index_declaration_loans_on_declaration_id"

  create_table "declaration_other_facts", :force => true do |t|
    t.integer  "declaration_id"
    t.text     "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "declaration_other_facts", ["declaration_id"], :name => "index_declaration_other_facts_on_declaration_id"

  create_table "declaration_other_workplaces", :force => true do |t|
    t.integer  "declaration_id"
    t.string   "position"
    t.string   "workplace"
    t.string   "registration_number"
    t.string   "legal_address"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "declaration_other_workplaces", ["declaration_id"], :name => "index_declaration_other_workplaces_on_declaration_id"

  create_table "declaration_real_estates", :force => true do |t|
    t.integer  "declaration_id"
    t.string   "kind"
    t.string   "location"
    t.string   "ownership_type"
    t.string   "other_owners"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "declaration_real_estates", ["declaration_id"], :name => "index_declaration_real_estates_on_declaration_id"

  create_table "declaration_relatives", :force => true do |t|
    t.integer  "declaration_id"
    t.string   "full_name"
    t.string   "kind"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "declaration_relatives", ["declaration_id"], :name => "index_declaration_relatives_on_declaration_id"

  create_table "declaration_securities", :force => true do |t|
    t.integer  "declaration_id"
    t.string   "issuer"
    t.string   "registration_number"
    t.string   "legal_address"
    t.string   "kind"
    t.integer  "units"
    t.decimal  "amount",              :precision => 15, :scale => 2
    t.string   "currency"
    t.decimal  "amount_lvl",          :precision => 15, :scale => 2
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.decimal  "amount_eur",          :precision => 15, :scale => 2
  end

  add_index "declaration_securities", ["declaration_id"], :name => "index_declaration_securities_on_declaration_id"

  create_table "declaration_vehicles", :force => true do |t|
    t.integer  "declaration_id"
    t.string   "kind"
    t.string   "model"
    t.integer  "release_year"
    t.integer  "registration_year"
    t.string   "ownership_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "declaration_vehicles", ["declaration_id"], :name => "index_declaration_vehicles_on_declaration_id"

  create_table "declarations", :force => true do |t|
    t.string   "kind"
    t.integer  "period_year"
    t.date     "status_on"
    t.string   "full_name"
    t.string   "workplace"
    t.string   "position"
    t.date     "submitted_on"
    t.date     "published_on"
    t.integer  "person_id"
    t.datetime "created_at",                                                                       :null => false
    t.datetime "updated_at",                                                                       :null => false
    t.integer  "import_declaration_id"
    t.integer  "declaration_other_workplaces_count",                                :default => 0
    t.integer  "declaration_real_estates_count",                                    :default => 0
    t.integer  "declaration_companies_count",                                       :default => 0
    t.integer  "declaration_securities_count",                                      :default => 0
    t.integer  "declaration_vehicles_count",                                        :default => 0
    t.integer  "declaration_cash_count",                                            :default => 0
    t.integer  "declaration_income_count",                                          :default => 0
    t.integer  "declaration_deals_count",                                           :default => 0
    t.integer  "declaration_debts_count",                                           :default => 0
    t.integer  "declaration_loans_count",                                           :default => 0
    t.integer  "declaration_relatives_count",                                       :default => 0
    t.integer  "declaration_children_count",                                        :default => 0
    t.decimal  "cash_amount_lvl",                    :precision => 15, :scale => 2
    t.decimal  "bank_amount_lvl",                    :precision => 15, :scale => 2
    t.decimal  "companies_amount_lvl",               :precision => 15, :scale => 2
    t.decimal  "deals_amount_lvl",                   :precision => 15, :scale => 2
    t.decimal  "debts_amount_lvl",                   :precision => 15, :scale => 2
    t.decimal  "income_amount_lvl",                  :precision => 15, :scale => 2
    t.decimal  "loans_amount_lvl",                   :precision => 15, :scale => 2
    t.decimal  "securities_amount_lvl",              :precision => 15, :scale => 2
    t.string   "project"
    t.decimal  "cash_amount_eur",                    :precision => 15, :scale => 2
    t.decimal  "bank_amount_eur",                    :precision => 15, :scale => 2
    t.decimal  "companies_amount_eur",               :precision => 15, :scale => 2
    t.decimal  "deals_amount_eur",                   :precision => 15, :scale => 2
    t.decimal  "debts_amount_eur",                   :precision => 15, :scale => 2
    t.decimal  "income_amount_eur",                  :precision => 15, :scale => 2
    t.decimal  "loans_amount_eur",                   :precision => 15, :scale => 2
    t.decimal  "securities_amount_eur",              :precision => 15, :scale => 2
    t.string   "head_md5"
  end

  add_index "declarations", ["head_md5", "project"], :name => "index_declarations_on_head_md5_and_project"
  add_index "declarations", ["import_declaration_id"], :name => "index_declarations_on_import_declaration_id"

  create_table "import_declarations", :force => true do |t|
    t.string   "status",     :default => "new"
    t.text     "data"
    t.string   "md5"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at"
    t.text     "error"
    t.string   "project"
  end

  add_index "import_declarations", ["md5", "project"], :name => "index_import_declarations_on_md5_and_project", :unique => true

  create_table "people", :force => true do |t|
    t.string   "full_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "person_code"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "declaration_hash"
  end

  add_index "people", ["declaration_hash"], :name => "index_people_on_declaration_hash"

  create_table "users", :force => true do |t|
    t.string   "email",                                                 :null => false
    t.boolean  "super_admin"
    t.boolean  "user_admin"
    t.boolean  "data_admin"
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "reset_password_sent_at"
    t.datetime "invitation_accepted_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
