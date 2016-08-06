class Course < ActiveRecord::Base
  belongs_to :cuco_session
  belongs_to :room
  belongs_to :period
end
