class Course < ActiveRecord::Base
  belongs_to :cuco_session
  has_one :room

  # allow one to use @course.room in views
  def room
    Room.find(assigned_room).name
  end
  
end
