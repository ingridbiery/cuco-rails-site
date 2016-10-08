class CreateCourseRoles < ActiveRecord::Migration
  def change
    create_table :course_roles do |t|
      t.string :name
      t.string :description
      t.boolean :is_worker
      t.integer :display_weight

      t.timestamps null: false
    end
  end
end
