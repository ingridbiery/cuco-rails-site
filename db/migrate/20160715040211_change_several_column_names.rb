class ChangeSeveralColumnNames < ActiveRecord::Migration
  def change
    rename_column :courses, :session_id, :cuco_session_id
    rename_column :courses, :min_num_students, :min_students
    rename_column :courses, :max_num_students, :max_students
    rename_column :courses, :course_fee, :fee
    rename_column :courses, :room_requirements, :room_reqs
    rename_column :courses, :time_requirements, :time_reqs
  end
end
