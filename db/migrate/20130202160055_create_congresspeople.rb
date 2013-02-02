class CreateCongresspeople < ActiveRecord::Migration
  def change
    create_table :congresspeople do |t|
      t.string :name
      t.string :crp_id
      t.string :party
      t.integer :state_id

      t.timestamps
    end
  end
end
