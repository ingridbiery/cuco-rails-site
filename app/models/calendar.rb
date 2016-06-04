class Calendar < ActiveRecord::Base
  belongs_to :cuco_session
  has_many :events, dependent: :destroy
end
