class AddGovtrackIdToCongresspersons < ActiveRecord::Migration
  def change
    add_column :congresspeople, :govtrack_id, :integer
  end
end
