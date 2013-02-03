class Party < ActiveRecord::Base
  attr_accessible :end, :start, :venue_city, :venue_state, :venue_zip, :host
  has_many :party_attendances
  has_many :congresspeople, :through => :party_attendances

  def pretty_host
    if self.host
      split_host = self.host.split(" || ")
      if split_host.size > 1
        h = split_host[0...-1].join(", ") + " and " + split_host[-1]
      else
        h = split_host[0]
      end

      if is_a_real_word(h.split(" ")[0])
        h = "the " + h
      end
      h
    else
      ""
    end
  end

  def pretty_beneficiary
    if self.beneficiary
      split_beneficiary = self.beneficiary.split(" || ")
      if split_beneficiary.size > 1
        h = split_beneficiary[0...-1].join(", ") + " and " + split_beneficiary[-1]
      else
        h = split_beneficiary[0]
      end

      if is_a_real_word(h.split(" ")[0])
        h = "the " + h
      end
      h
    else
      ""
    end

  end

  def similar_enough(congressperson_name_1, congressperson_name_2, threshold)
    require 'levenshtein'
    return Levenshtein.distance(congressperson_name_1, congressperson_name_2) <= threshold * [congressperson_name_2.size, congressperson_name_1.size].max
  end

  def is_a_real_word(word)
    $words ||= open("/usr/share/dict/words").read.split("\n")
    $words.include?(word.downcase)
  end 

  def short_description
    #return, with preposition, a short phrase describing the party
    #e.g. "with John Smith and Barack Obama" or "at Chuckie Cheese's"
    if self.host
      " at an event hosted by " + self.pretty_host
    elsif self.beneficiary 
      #this is super hacky
      if similar_enough(self.beneficiary, self.congresspeople[0].name, 0.75)
        " on #{self.congresspeople[0].gender == "F" ? "her" : "his"} own behalf"
      else
        if self.beneficiary.split(" || ").size > 1
          "on behalf of " + self.beneficiary.split(" || ")[0...-1].join(", ") + " and " + self.beneficiary.split(" || ")[-1]
        else
          " on behalf of " + (is_a_real_word(self.beneficiary.split(" ")[0]) ? "the " : "" ) + self.beneficiary
        end
      end
    elsif self.venue_name && self.venue_city && self.venue_state
      " at " + self.venue_name + " in " + self.venue_city + ", " + self.venue_state
    elsif self.venue_name
      " at " + self.venue_name
    elsif self.entertainment
      " where " + self.entertainment + " performed"
    end
  end
end
