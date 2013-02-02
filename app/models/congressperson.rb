class Congressperson < ActiveRecord::Base
  attr_accessible :crp_id, :name, :party, :state_id
  has_many :party_attendances
  has_many :parties, :through => :party_attendances
  has_many :missed_votes
  belongs_to :state

  def pronoun
    self.gender == "F" ? "she" : "he"
  end
end
