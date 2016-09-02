class CourseSignup < ActiveRecord::Base
  include ActiveWarnings
  
  belongs_to :course
  belongs_to :person
  validates :person_id, :uniqueness => {:scope=>:course_id, :message => "person already signed up for course"}

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

    def student_age_suggestion
      if !course.age_firm
        student_age
      end
    end
  end

end
