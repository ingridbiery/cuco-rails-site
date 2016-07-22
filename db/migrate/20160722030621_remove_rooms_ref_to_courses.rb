class RemoveRoomsRefToCourses < ActiveRecord::Migration
  def change
    remove_column :users, :courses_id, :integer
    remove_index :rooms, column: :courses_id
  end
end
