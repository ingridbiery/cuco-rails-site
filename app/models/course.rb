class Course < ActiveRecord::Base
  belongs_to :cuco_session
  belongs_to :room
  belongs_to :period

  # allow one to use @course.room in views
  def room
    Room.find(room_id).name
  end
  
  def period
    Period.find(period_id).name
  end
end
