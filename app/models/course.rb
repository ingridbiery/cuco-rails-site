class Course < ActiveRecord::Base
  belongs_to :cuco_session
  belongs_to :room
  belongs_to :period

  validates :title, presence: true,
                    length: { minimum: 5, maximum: 75 }

  validates :short_title, presence: true,
                    length: { minimum: 3, maximum: 15 }

  validates :description, presence: true

  validates :min_age, length: { maximum: 3 }, numericality: true
  validates :max_age, length: { maximum: 3 }, numericality: true

  validates :min_students, length: { maximum: 3 }, numericality: true
  validates :max_students, length: { maximum: 3 }, numericality: true

  validates :fee, length: { maximum: 5 }, numericality: true, allow_blank: true

  validate :age_ranges
  validate :student_ranges

  private
  
  # Check to see if min_age is less than max_age
  def age_ranges
    if max_age.to_i < min_age.to_i
      errors.add("Max age", "(#{max_age}) is not greater than min age (#{min_age})")
    end
  end
  
  # Check to see if min_students is less than max_students
  def student_ranges
    if max_students.to_i < min_students.to_i
      errors.add("Max students", "(#{max_students}) is not greater than min students (#{min_students})")
    end
  end
  
end
