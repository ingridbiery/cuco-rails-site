class ChangeAssignedRoomToInteger < ActiveRecord::Migration
  def change
    change_column :courses, :assigned_room, :integer
    rename_column :courses, :assigned_room, :room_id
    rename_column :courses, :assigned_period, :period_id
    add_foreign_key :courses, :periods
    add_foreign_key :courses, :rooms
    add_index :courses, :period_id
    add_index :courses, :room_id
  end
end
