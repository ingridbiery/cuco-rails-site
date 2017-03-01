class CoursesAddSignupsToAdd < ActiveRecord::Migration
  def change
    add_column :courses, :signups_to_add, :text
  end
end
