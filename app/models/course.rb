class Course < ActiveRecord::Base
  belongs_to :cuco_session
  belongs_to :room_params
  belongs_to :period
end
