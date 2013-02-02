class AddStuffToParties < ActiveRecord::Migration
  def change
    add_column :parties, :beneficiary, :string
    add_column :parties, :host, :string
    add_column :parties, :entertainment, :string
    add_column :parties, :venue_name, :string
    add_column :parties, :contrib, :string
    add_column :parties, :payable_to, :string
    add_column :parties, :canceled, :string
    add_column :parties, :postponed, :string
  end
end
