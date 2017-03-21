class RemoveRoomIdFromCourse < ActiveRecord::Migration
  def change
    remove_column :courses, :room_id, :string
  end
end
