class AddIsAwayToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :is_away, :boolean, :default => false
  end
end
