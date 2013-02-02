class CreateMissedVotes < ActiveRecord::Migration
  def change
    create_table :missed_votes do |t|
      t.integer :congressperson_id
      t.integer :govtrack_vote_id
      t.integer :govtrack_resource_id
      t.datetime :created

      t.timestamps
    end
  end
end
