class CreateCourseSignups < ActiveRecord::Migration
  def change
    create_table :course_signups do |t|
      t.references :course, index: true, foreign_key: true
      t.references :person, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
