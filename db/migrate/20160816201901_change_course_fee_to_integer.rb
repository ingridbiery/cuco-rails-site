class ChangeCourseFeeToInteger < ActiveRecord::Migration
  def change
    remove_column :courses, :fee, :float
    add_column :courses, :fee, :integer
  end
end
