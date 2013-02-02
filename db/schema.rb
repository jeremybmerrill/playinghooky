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

ActiveRecord::Schema.define(:version => 20130202234320) do

  create_table "absences", :force => true do |t|
    t.integer  "missed_vote_id"
    t.integer  "party_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.boolean  "strict"
  end

  create_table "congresspeople", :force => true do |t|
    t.string   "name"
    t.string   "crp_id"
    t.string   "party"
    t.integer  "state_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "govtrack_id"
    t.string   "gender"
  end

  add_index "congresspeople", ["crp_id"], :name => "index_congresspeople_on_crp_id"
  add_index "congresspeople", ["govtrack_id"], :name => "index_congresspeople_on_govtrack_id"

  create_table "full_votes", :force => true do |t|
    t.integer  "missed_vote_id"
    t.string   "category_label"
    t.string   "result"
    t.string   "link"
    t.integer  "congress"
    t.string   "status"
    t.string   "number"
    t.text     "title"
    t.string   "thomas_link"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "missed_votes", :force => true do |t|
    t.integer  "congressperson_id"
    t.integer  "govtrack_vote_id"
    t.integer  "govtrack_resource_id"
    t.datetime "vote_time"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "parties", :force => true do |t|
    t.datetime "start"
    t.datetime "end"
    t.string   "venue_city"
    t.string   "venue_state"
    t.string   "venue_zip"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "sunlight_key"
    t.string   "beneficiary"
    t.string   "host"
    t.string   "entertainment"
    t.string   "venue_name"
    t.string   "contrib"
    t.string   "payable_to"
    t.string   "canceled"
    t.string   "postponed"
  end

  add_index "parties", ["sunlight_key"], :name => "index_parties_on_sunlight_key"

  create_table "party_attendances", :force => true do |t|
    t.integer  "party_id"
    t.integer  "congressperson_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "party_attendances", ["congressperson_id"], :name => "index_party_attendances_on_congressperson_id"
  add_index "party_attendances", ["party_id"], :name => "index_party_attendances_on_party_id"

  create_table "states", :force => true do |t|
    t.string   "abbrev"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "states", ["abbrev"], :name => "index_states_on_abbrev"

end
