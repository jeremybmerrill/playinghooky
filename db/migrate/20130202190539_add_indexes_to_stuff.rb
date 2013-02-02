class AddIndexesToStuff < ActiveRecord::Migration
  def change
    add_index :congresspeople, :govtrack_id
    add_index :congresspeople, :crp_id
    add_index :parties, :sunlight_key
    add_index :states, :abbrev
    add_index :party_attendances, :congressperson_id
    add_index :party_attendances, :party_id
  end
end
