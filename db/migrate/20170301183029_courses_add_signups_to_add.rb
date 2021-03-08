class CoursesAddSignupsToAdd < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :signups_to_add, :text
  end
end
