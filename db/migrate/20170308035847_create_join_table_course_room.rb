class CreateJoinTableCourseRoom < ActiveRecord::Migration[4.2]
  def change
    create_join_table :courses, :rooms do |t|
      t.index [:course_id, :room_id]
      t.index [:room_id, :course_id]
    end
  end
end
