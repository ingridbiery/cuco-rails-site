class CourseSignup < ActiveRecord::Base
  include ActiveWarnings
  
  belongs_to :course
  belongs_to :person
  belongs_to :course_role

  scope :student, -> { joins(:course_role).where(course_roles: { name: :student }) }
  scope :waiting_list, -> { joins(:course_role).where(course_roles: { name: :waiting_list }) }
  scope :unassigned_volunteer, -> { joins(:course_role).where(course_roles: { name: :unassigned_volunteer }) }
  scope :non_student_non_worker, -> { joins(:course_role).where(course_roles: { name: :non_student_non_worker }) }
  scope :volunteer, -> { joins(:course_role).where(course_roles: { is_worker: true }) }
  
  validate :person_validity
  validate :course_capacity
  validate :student_age_firm

  def course_capacity
    if course.max_students == course.student_signups.count
      errors.add("Max students", "has been reached")
    end
  end
  
  def student_age_firm
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
  
  # get a name to display in the notice
  def name
    result = course_role.name
    if person
      result += " : #{person.name}"
    end
    result
  end


  warnings do
    validate :student_age_suggestion
    validate :one_signup_per_period

    def student_age_suggestion
      if !course.age_firm
        check_student_age
      end
    end
    
    def one_signup_per_period
      pid = course.period.id
      csid = course.cuco_session.id
      signups = CourseSignup.where(person: person).joins(:course).where(courses: {cuco_session_id: csid,
                                                                                  period_id: pid})
      if signups.count != 0
        errors.add("Person", "already has another class this period")
      end
    end
    
    def person_validity
      # if this is a not a job, it needs a person
      if !course_role.is_worker and !person
        errors.add("Person", "is blank for a non-worker role: #{course_role.name}")
      end
    end
  end

end
