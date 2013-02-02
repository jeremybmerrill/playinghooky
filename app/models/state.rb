class State < ActiveRecord::Base
  attr_accessible :abbrev, :name
  has_many :congresspeople
end
