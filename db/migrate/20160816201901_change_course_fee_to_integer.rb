class ChangeCourseFeeToInteger < ActiveRecord::Migration[4.2]
  def change
    remove_column :courses, :fee, :float
    add_column :courses, :fee, :integer
  end
end
