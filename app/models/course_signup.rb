class CourseSignup < ActiveRecord::Base
  belongs_to :course
  belongs_to :person
end
