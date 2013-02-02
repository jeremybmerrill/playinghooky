class Party < ActiveRecord::Base
  attr_accessible :end, :start, :venue_city, :venue_state, :venue_zip
  has_many :party_attendances
  has_many :congresspeople, :through => :party_attendances

  def pretty_host
    split_host = host.split(" || ")
    split_host[0...-1].join(", ") + " and " + split_host[-1]
  end

  def short_description
    #return, with preposition, a short phrase describing the party
    #e.g. "with John Smith and Barack Obama" or "at Chuckie Cheese's"
    if self.host
      "hosted by " + self.pretty_host
    elsif self.beneficiary
      "on behalf of " + self.beneficiary
    elsif self.venue_name && self.venue_city && self.venue_state
      "at " + self.venue_name + " in " + self.venue_city + ", " + self.venue_state
    elsif self.venue_name
      "at " + self.venue_name
    elsif self.entertainment
      "where " + self.entertainment + " performed"
    end
  end
end
