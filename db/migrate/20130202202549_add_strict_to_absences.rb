class AddStrictToAbsences < ActiveRecord::Migration
  def change
    add_column :absences, :strict, :boolean
  end
end
