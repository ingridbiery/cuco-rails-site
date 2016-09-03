require 'test_helper'

class CourseSignupTest < ActiveSupport::TestCase
  def setup
    @course_signup = course_signups(:one)
    @adult = people(:kimberly)
  end

  test "should be valid" do
    assert @course_signup.valid?
  end

  #############################################################################
  # unique
  #############################################################################
  
  test "person/course pair should be unique" do
    new_signup = @course_signup.dup
    assert_not new_signup.valid?
  end

  #############################################################################
  # course full
  #############################################################################
  
  test "signup should not be allowed when course is full" do
    course = @course_signup.course
    course.max_students = course.people.count
    course.save
    new_signup = @course_signup.dup
    new_signup.person = @person
    assert_not new_signup.valid?
  end
  
  #############################################################################
  # too young
  #############################################################################

  test "too young signup should not be allowed when age firm" do
    course = @course_signup.course
    course.age_firm = true
    course.min_age = @course_signup.person.age + 1
    course.save
    assert_not @course_signup.valid?
  end

  test "adult can't be too young even when age firm" do
    course = @course_signup.course
    course.age_firm = true
    course.save
    @course_signup.person = @adult
    assert @course_signup.valid?
  end

  test "too young signup should generate warning when age not firm" do
    course = @course_signup.course
    course.age_firm = false
    course.min_age = @course_signup.person.age + 1
    course.save
    assert @course_signup.valid?
    assert_not @course_signup.safe?
  end

  #############################################################################
  # too old
  #############################################################################

  test "too old signup should not be allowed when age firm" do
    course = @course_signup.course
    course.age_firm = true
    course.max_age = @course_signup.person.age - 1
    course.save
    assert_not @course_signup.valid?
  end

  test "adult can't be too old even when age firm" do
    course = @course_signup.course
    course.age_firm = true
    course.save
    @course_signup.person = @adult
    assert @course_signup.valid?
  end

  test "too old signup should generate warning when age not firm" do
    course = @course_signup.course
    course.age_firm = false
    course.max_age = @course_signup.person.age - 1
    course.save
    assert @course_signup.valid?
    assert_not @course_signup.safe?
  end

end
