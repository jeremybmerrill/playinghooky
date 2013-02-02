class PartyAttendance < ActiveRecord::Base
  attr_accessible :congressperson_id, :party_id
  belongs_to :congressperson
  belongs_to :party
end
