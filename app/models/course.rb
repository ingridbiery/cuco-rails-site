class Course < ActiveRecord::Base
  belongs_to :cuco_session
  has_one :room_params
  has_one :period
end
