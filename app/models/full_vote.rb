class FullVote < ActiveRecord::Base
  attr_accessible :category_label, :congress, :link, :missed_vote_id, :number, :result, :status, :thomas_link, :title
  belongs_to :missed_vote
end
