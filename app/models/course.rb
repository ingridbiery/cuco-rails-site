class Course < ActiveRecord::Base
  belongs_to :cuco_session
  belongs_to :room
  belongs_to :period
  has_many :course_signups
  has_many :people, through: :course_signups

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 100 }

  validates :short_name, presence: true,
                         length: { minimum: 3, maximum: 30 }

  validates :description, presence: true

  validates :min_age, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }
  validates :max_age, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }

  validates :min_students, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }
  validates :max_students, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }

  validates :fee, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 999 }

  validate :age_ranges
  validate :student_ranges

  private
  
  # Check to see if min_age is less than max_age
  def age_ranges
    if max_age.to_i <= min_age.to_i
      errors.add("Max age", "(#{max_age}) is not greater than min age (#{min_age})")
    end
  end
  
  # Check to see if min_students is less than max_students
  def student_ranges
    if max_students.to_i <= min_students.to_i
      errors.add("Max students", "(#{max_students}) is not greater than min students (#{min_students})")
    end
  end
  
end
