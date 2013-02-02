class ChangeNameOfCreatedOnMissedVotes < ActiveRecord::Migration
  def up
    rename_column :missed_votes, :created, :vote_time
  end

  def down
    rename_column :missed_votes, :vote_time, :created
  end
end
