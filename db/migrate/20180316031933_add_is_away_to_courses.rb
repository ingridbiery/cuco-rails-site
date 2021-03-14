class AddIsAwayToCourses < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :is_away, :boolean, :default => false
  end
end
