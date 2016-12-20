class Course < ActiveRecord::Base
  belongs_to :cuco_session
  belongs_to :room
  belongs_to :period
  belongs_to :created_by, class_name: "User"
  
  has_many :course_signups, dependent: :destroy
  has_many :people, through: :course_signups
  has_many :student_signups, -> { CourseSignup.student }, class_name: 'CourseSignup', foreign_key: :course_id
  has_many :waiting_list_signups, -> { CourseSignup.waiting_list }, class_name: 'CourseSignup', foreign_key: :course_id
  has_many :unassigned_volunteer_signups, -> { CourseSignup.unassigned_volunteer }, class_name: 'CourseSignup', foreign_key: :course_id
  has_many :non_student_non_worker_signups, -> { CourseSignup.non_student_non_worker }, class_name: 'CourseSignup', foreign_key: :course_id
  has_many :volunteer_signups, -> { CourseSignup.volunteer }, class_name: 'CourseSignup', foreign_key: :course_id

  scope :assigned, -> { where.not(period_id: nil).where.not(room_id: nil) }

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
  validates :created_by_id, presence: true

  validate :age_ranges
  validate :student_ranges

  def full
    student_signups.count >= max_students
  end

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
