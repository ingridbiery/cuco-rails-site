class ChangeAssignedRoomToInteger < ActiveRecord::Migration
  def change
    change_column :courses, :assigned_room, :integer
  end
end
