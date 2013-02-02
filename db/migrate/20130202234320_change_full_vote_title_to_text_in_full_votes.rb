class ChangeFullVoteTitleToTextInFullVotes < ActiveRecord::Migration
  def up
    change_column :full_votes, :title, :text
  end

  def down
    change_column :full_votes, :title, :string
  end
end
