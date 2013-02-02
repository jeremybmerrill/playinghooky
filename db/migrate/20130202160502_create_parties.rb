class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.datetime :start
      t.datetime :end
      t.string :venue_city
      t.string :venue_state
      t.string :venue_zip

      t.timestamps
    end
  end
end
