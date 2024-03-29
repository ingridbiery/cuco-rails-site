
class Course < ActiveRecord::Base
  belongs_to :cuco_session
  has_and_belongs_to_many :rooms
  belongs_to :period
  belongs_to :created_by, class_name: "User"

  has_many :course_signups, dependent: :destroy
  has_many :people, through: :course_signups

  has_many :student_signups, -> { CourseSignup.student }, class_name: 'CourseSignup', foreign_key: :course_id
  has_many :waiting_list_signups, -> { CourseSignup.waiting_list_member }, class_name: 'CourseSignup', foreign_key: :course_id
  has_many :on_call_volunteer_signups, -> { CourseSignup.on_call_volunteer }, class_name: 'CourseSignup', foreign_key: :course_id
  has_many :person_in_room_signups, -> { CourseSignup.person_in_room }, class_name: 'CourseSignup', foreign_key: :course_id
  has_many :volunteer_signups, -> { CourseSignup.volunteer }, class_name: 'CourseSignup', foreign_key: :course_id
  has_many :helper_signups, -> { CourseSignup.helper }, class_name: 'CourseSignup', foreign_key: :course_id
  has_many :teacher_signups, -> { CourseSignup.teacher }, class_name: 'CourseSignup', foreign_key: :course_id
  has_many :adult_signups, -> { CourseSignup.adult }, class_name: 'CourseSignup', foreign_key: :course_id

# was assigned_period until I broke something
  scope :assigned, -> { where.not(period_id: nil) }
#  scope :assigned_room, -> { left_outer_joins(:rooms).where.not(rooms: { id: nil }).order(:name) }
#  scope :assigned, -> { assigned_period.assigned_room.order(:name) }
#  scope :unassigned, -> { left_outer_joins(:rooms).where("period_id IS NULL OR rooms.id IS NULL").order(:name) }
  scope :not_away, -> { where(is_away: false) } # courses that don't represent being away from co-op

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

  # is this one of the special courses for volunteers and free play?
  def is_vols?
    name.include?("Volunteers") and name.include?("Free Play")
  end

  def full
    student_signups.count >= max_students
  end

  def total_fees
    fee * student_signups.count
  end

  def teacher_names
    teachers = []
    teacher_signups.each { |signup| teachers << signup.person.name }
    teachers.join(", ")
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
