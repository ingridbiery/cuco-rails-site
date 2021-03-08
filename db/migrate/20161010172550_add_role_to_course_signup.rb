class AddRoleToCourseSignup < ActiveRecord::Migration[4.2]
  def change
    add_reference :course_signups, :course_role, index: true, foreign_key: true
  end
end
