class MissedVote < ActiveRecord::Base
  attr_accessible :congressperson_id, :created, :govtrack_resource_id, :govtrack_vote_id, :strict
  belongs_to :congressperson
  has_one :full_vote
end
