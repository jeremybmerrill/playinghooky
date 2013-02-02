class CreatePartyAttendances < ActiveRecord::Migration
  def change
    create_table :party_attendances do |t|
      t.integer :party_id
      t.integer :congressperson_id

      t.timestamps
    end
  end
end
