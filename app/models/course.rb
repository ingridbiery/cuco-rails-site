class Course < ActiveRecord::Base
  belongs_to :cuco_session
  has_one :room
end
