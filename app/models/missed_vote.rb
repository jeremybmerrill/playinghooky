class MissedVote < ActiveRecord::Base
  attr_accessible :congressperson_id, :created, :govtrack_resource_id, :govtrack_vote_id
  belongs_to :congressperson
end