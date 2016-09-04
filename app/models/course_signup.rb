class CourseSignup < ActiveRecord::Base
  include ActiveWarnings
  
  belongs_to :course
  belongs_to :person
  validates :person_id, :uniqueness => {:scope=>:course_id, :message => "already signed up for course"}

  validate :course_capacity
  validate :student_age_firm

  def course_capacity
    if course.max_students == course.people.count
      errors.add("Max students", "has been reached")
    end
  end
  
  def student_age_firm
    if course.age_firm
      student_age
    end
  end
  
  def student_age
    age = person.age_on(course.cuco_session.start_date)
    if age != nil
      if age < course.min_age
        errors.add("Student", "too young for course")
      elsif age > course.max_age
        errors.add("Student", "too old for course")
      end
    end
  end

  warnings do
    validate :student_age_suggestion
    validate :one_signup_per_period

    def student_age_suggestion
      if !course.age_firm
        student_age
      end
    end
    
    def one_signup_per_period
      pid = course.period.id
      csid = course.cuco_session.id
      signups = CourseSignup.where(person: person).joins(:course).where(courses: {cuco_session_id: csid,
                                                                                  period_id: pid})
      if signups.count != 0
        errors.add("Student", "already has another class this period")
      end
    end
  end

end
