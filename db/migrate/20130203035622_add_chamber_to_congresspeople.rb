class AddChamberToCongresspeople < ActiveRecord::Migration
  def change
    add_column :congresspeople, :chamber, :string
  end
end
