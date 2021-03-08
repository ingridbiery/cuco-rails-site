class CreateCourses < ActiveRecord::Migration[4.2]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :short_title
      t.text :description
      t.integer :min_age
      t.integer :max_age
      t.boolean :age_firm
      t.integer :min_num_students
      t.integer :max_num_students
      t.float :course_fee
      t.text :supplies
      t.text :room_requirements
      t.text :time_requirements
      t.boolean :drop_ins
      t.text :additional_info
      t.string :assigned_room
      t.integer :assigned_period
      t.integer :session_id

      t.timestamps null: false
    end
  end
end
