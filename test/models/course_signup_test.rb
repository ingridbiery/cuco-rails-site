require 'test_helper'

class CourseSignupTest < ActiveSupport::TestCase
  def setup
    @course_signup = course_signups(:one)
    @adult = people(:lisa)
    @course1 = courses(:one)
    @course2 = courses(:two)
    @period1 = periods(:first)
  end

  test "should be valid" do
    # change the person so we don't have a duplicate signup
    @course_signup.person = people(:emma)
    assert @course_signup.valid?
  end

  #############################################################################
  # duplicates
  #############################################################################
  
  test "person/course pair should be unique" do
    new_signup = @course_signup.dup
    assert_not new_signup.valid?
  end

  test "warn when person signed up for another course in same period" do
    @course1.period = @period1
    @course1.save
    @course_signup.course = @course1
    @course_signup.save
    @course2.period = @period1
    @course2.cuco_session_id = @course1.cuco_session_id
    @course2.save
    new_signup = @course_signup.dup
    new_signup.course = @course2
    assert new_signup.valid?
    assert_not new_signup.safe?
  end

  #############################################################################
  # course full
  #############################################################################
  
  test "signup should not be allowed when course is full" do
    course = @course_signup.course
    course.max_students = course.student_signups.count
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
    @course_signup.person = people(:emma)
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
    @course_signup.person = people(:emma)
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
    @course_signup.person = people(:emma)
    course.age_firm = false
    course.max_age = @course_signup.person.age - 1
    course.save
    assert @course_signup.valid?
    assert_not @course_signup.safe?
  end

end
