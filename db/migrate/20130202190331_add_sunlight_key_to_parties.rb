class AddSunlightKeyToParties < ActiveRecord::Migration
  def change
    add_column :parties, :sunlight_key, :integer
  end
end
