class CourseSignup < ActiveRecord::Base
  include ActiveWarnings

  belongs_to :course
  belongs_to :person, optional: true
  belongs_to :course_role

  scope :student, -> { joins(:course_role).merge(CourseRole.student) }
  scope :waiting_list_member, -> { joins(:course_role).merge(CourseRole.waiting_list_member) }
  scope :on_call_volunteer, -> { joins(:course_role).merge(CourseRole.on_call_volunteer) }
  scope :person_in_room, -> { joins(:course_role).merge(CourseRole.person_in_room) }
  scope :teacher, -> { joins(:course_role).merge(CourseRole.teacher) }
  scope :volunteer, -> { joins(:course_role).merge(CourseRole.volunteer) }
  scope :helper, -> { joins(:course_role).merge(CourseRole.helper) }
  scope :non_working_role, -> { joins(:course_role).merge(CourseRole.non_working_role) }
  scope :adult, -> { joins(:person).merge(Person.adult) }

  validate :course_capacity
  validate :student_age_if_firm
  validate :person_validity

  # get a name to display notices
  def name
    result = course_role.name
    if person
      result += " : #{person.name}"
    end
    result
  end

  def course_capacity
    if course.max_students == course.student_signups.count and
       course_role.name == "student" then
      errors.add("Max students", "has been reached")
    end
  end

  def student_age_if_firm
    if course.age_firm
      check_student_age
    end
  end

  def check_student_age
    if course_role.name.to_sym == :student
      age = person.age_on(course.cuco_session.start_date)
      if age != nil
        if age < course.min_age
          errors.add("Student", "too young for course")
        elsif age > course.max_age
          errors.add("Student", "too old for course")
        end
      end
    end
  end

  # if this is a not a job, it needs a person
  def person_validity
    if !course_role.can_be_unassigned? and !person
      errors.add("Person", "is blank for a non-worker role: #{course_role.name}")
    end
  end

  warnings do
    validate :student_age_if_suggestion
    validate :one_signup

    def student_age_if_suggestion
      if !course.age_firm
        check_student_age
      end
    end

    # check for multiple signups this period.
    def one_signup
      pid = course.period&.id
      if pid
        csid = course.cuco_session.id
        signups = CourseSignup.where(person: person).joins(:course).where(courses: {cuco_session_id: csid,
                                                                                    period_id: pid})
        # if this signup is already there, make sure it's the only one, otherwise make
        # sure there are none.
        if signups.count != signups.where(id: id).count
          errors.add("Person", "already has another signup this period")
        end
      end
    end

    # we're now allowing more than one signup per period (for jobs outside of co-op, typically)
    # def one_signup_per_class
    #   if person
    #     signups = CourseSignup.where(person: person).where(course: course)
    #     # if there is another signup for this person and it's not this signup
    #     if signups.count != 0 and signups.first.id != id
    #       errors.add("Person", "already signed up for this course")
    #     end
    #   end
    # end
    #
  end

end
