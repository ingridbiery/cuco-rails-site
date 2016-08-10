class ChangeAssignedRoomToInteger < ActiveRecord::Migration
  def change
    remove_column :courses, :assigned_room, :string
    add_column :courses, :room_id, :integer
    rename_column :courses, :assigned_period, :period_id
    add_foreign_key :courses, :periods
    add_foreign_key :courses, :rooms
    add_index :courses, :period_id
    add_index :courses, :room_id
  end
end
