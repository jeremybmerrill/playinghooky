class Absence < ActiveRecord::Base
  attr_accessible :missed_vote_id, :party_id
  belongs_to :missed_vote
  belongs_to :party 
end
