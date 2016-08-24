class ChangeCourseTitleToName < ActiveRecord::Migration
  def change
    rename_column :courses, :title, :name
    rename_column :courses, :short_title, :short_name
  end
end
