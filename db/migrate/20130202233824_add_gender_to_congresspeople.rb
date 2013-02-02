class AddGenderToCongresspeople < ActiveRecord::Migration
  def change
    add_column :congresspeople, :gender, :string
  end
end
