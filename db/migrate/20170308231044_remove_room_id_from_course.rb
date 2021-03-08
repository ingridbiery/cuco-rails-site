class RemoveRoomIdFromCourse < ActiveRecord::Migration[4.2]
  def change
    remove_column :courses, :room_id, :string
  end
end
