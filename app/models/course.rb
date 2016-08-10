class Course < ActiveRecord::Base
  belongs_to :cuco_session
  belongs_to :room
  belongs_to :period

  # allow one to use @course.room in views
  def room
    Room.find(assigned_room).name
  end
  
end
