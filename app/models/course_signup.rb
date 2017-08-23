class CourseSignup < ActiveRecord::Base
  include ActiveWarnings
  
  belongs_to :course
  belongs_to :person
  belongs_to :course_role

  scope :student, -> { joins(:course_role).where(course_roles: { name: :student }) }
  scope :waiting_list, -> { joins(:course_role).where(course_roles: { name: :waiting_list }) }
  scope :unassigned_volunteer, -> { joins(:course_role).where(course_roles: { name: :unassigned_volunteer }) }
  scope :people_in_room, -> { joins(:course_role).where(course_roles: { name: :person_in_room }) }
  scope :volunteer, -> { joins(:course_role).where(course_roles: { is_worker: true }) }
  
  validate :course_capacity
  validate :student_age_if_firm
  validate :person_validity
  # it's always illegal to have multiple signups per class, but a warning to have multiple signups per period
  validate :one_signup_per_class

  # is this a volunteer job?
  def is_volunteer_job?
    course_role.is_worker?
  end
  
  # is this an unassigned volunteer?
  def is_unassigned?
    course_role.name.to_sym == :unassigned_volunteer
  end

  # is this a student
  def is_student?
    course_role.name.to_sym == :student
  end    

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
    if !course_role.is_worker and !person
      errors.add("Person", "is blank for a non-worker role: #{course_role.name}")
    end
  end
  
  def one_signup_per_class
    if person
      signups = CourseSignup.where(person: person).where(course: course)
      # if there is another signup for this person and it's not this signup
      if signups.count != 0 and signups.first.id != id
        errors.add("Person", "already signed up for this course")
      end
    end
  end

  warnings do
    validate :student_age_if_suggestion
    validate :one_signup_per_period

    def student_age_if_suggestion
      if !course.age_firm
        check_student_age
      end
    end
    
    def one_signup_per_period
      pid = course.period.id
      if pid
        csid = course.cuco_session.id
        signups = CourseSignup.where(person: person).joins(:course).where(courses: {cuco_session_id: csid,
                                                                                    period_id: pid})
        # if this signup is already there, make sure it's the only one, otherwise make
        # sure there are none.
        if signups.count != signups.where(id: id).count
          errors.add("Person", "already has another class this period")
        end
      end
    end
    
  end

end
