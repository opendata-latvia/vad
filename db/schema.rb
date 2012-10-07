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

ActiveRecord::Schema.define(:version => 20121007091103) do

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
  end

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
  end

  create_table "declaration_deals", :force => true do |t|
    t.integer  "declaration_id"
    t.string   "description"
    t.decimal  "amount",         :precision => 15, :scale => 2
    t.string   "currency"
    t.decimal  "amount_lvl",     :precision => 15, :scale => 2
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "declaration_debts", :force => true do |t|
    t.integer  "declaration_id"
    t.decimal  "amount",          :precision => 15, :scale => 2
    t.string   "currency"
    t.decimal  "amount_lvl",      :precision => 15, :scale => 2
    t.string   "amount_in_words"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.text     "description"
  end

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
  end

  create_table "declaration_loans", :force => true do |t|
    t.integer  "declaration_id"
    t.decimal  "amount",          :precision => 15, :scale => 2
    t.string   "currency"
    t.decimal  "amount_lvl",      :precision => 15, :scale => 2
    t.string   "amount_in_words"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.text     "description"
  end

  create_table "declaration_other_facts", :force => true do |t|
    t.integer  "declaration_id"
    t.text     "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "declaration_other_workplaces", :force => true do |t|
    t.integer  "declaration_id"
    t.string   "position"
    t.string   "workplace"
    t.string   "registration_number"
    t.string   "legal_address"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "declaration_real_estates", :force => true do |t|
    t.integer  "declaration_id"
    t.string   "kind"
    t.string   "location"
    t.string   "ownership_type"
    t.string   "other_owners"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "declaration_relatives", :force => true do |t|
    t.integer  "declaration_id"
    t.string   "full_name"
    t.string   "kind"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

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
  end

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
  end

  create_table "import_declarations", :force => true do |t|
    t.string    "status",     :default => "new"
    t.text      "data"
    t.string    "md5"
    t.timestamp "created_at",                    :null => false
    t.datetime  "updated_at"
    t.text      "error"
  end

  create_table "people", :force => true do |t|
    t.string   "full_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "person_code"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "declaration_hash"
  end

end
