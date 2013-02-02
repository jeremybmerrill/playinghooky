class CreateAbsences < ActiveRecord::Migration
  def change
    create_table :absences do |t|
      t.integer :missed_vote_id
      t.integer :party_id

      t.timestamps
    end
  end
end
