class FullVote < ActiveRecord::Base
  attr_accessible :category_label, :congress, :link, :missed_vote_id, :number, :result, :status, :thomas_link, :title
  belongs_to :missed_vote

  def passed?
    ["Agreed to", "Passed"].include?(self.result)
  end

  def underlying_bill_passed?
    ["enacted_signed", "passed_simpleres"].include?(self.status)
   end
end
