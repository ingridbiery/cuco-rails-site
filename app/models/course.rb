class Course < ActiveRecord::Base
  belongs_to :cuco_session
  belongs_to :room
  belongs_to :period

  validates :title, presence: true,
                    length: { maximum: 75 }

  validates :short_title, presence: true,
                    length: { maximum: 15 }

  validates :description, presence: true

  validates :min_age, length: { maximum: 3 }, numericality: true
  validates :max_age, length: { maximum: 3 }, numericality: true

  validates :min_students, length: { maximum: 3 }, numericality: true
  validates :max_students, length: { maximum: 3 }, numericality: true

  validates :fee, length: { maximum: 5 }, numericality: true, allow_blank: true

end
