class CreateFullVotes < ActiveRecord::Migration
  def change
    create_table :full_votes do |t|
      t.integer :missed_vote_id
      t.string :category_label
      t.string :result
      t.string :link
      t.integer :congress
      t.string :status
      t.string :number
      t.string :title
      t.string :thomas_link

      t.timestamps
    end
  end
end
