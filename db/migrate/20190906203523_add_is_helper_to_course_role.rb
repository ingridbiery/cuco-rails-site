class AddIsHelperToCourseRole < ActiveRecord::Migration[5.1]
  def change
    add_column :course_roles, :is_helper, :boolean
  end
end
