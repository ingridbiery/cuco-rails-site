require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  def setup
    @course = courses(:one)
  end

  test "should be valid" do
    assert @course.valid?
  end

  #############################################################################
  # name
  #############################################################################

  test "name should be present" do
   @course.name = nil
   assert_not @course.valid?
  end

  test "name should not be too short" do
    @course.short_name = "a" * 2
    assert_not @course.valid?
  end

  test "name should not be too long" do
     @course.name = "a" * 101
     assert_not @course.valid?
  end

  #############################################################################
  # short name
  #############################################################################

  test "short name should be present" do
    @course.short_name = nil
    assert_not @course.valid?
  end

  test "short name should not be too short" do
    @course.short_name = "a" * 2
    assert_not @course.valid?
  end

  test "short name should not be too long" do
     @course.short_name = "a" * 31
     assert_not @course.valid?
  end

  #############################################################################
  # description
  #############################################################################

  test "description should be present" do
    @course.description = nil
    assert_not @course.valid?
  end

  #############################################################################
  # min age
  #############################################################################

  test "min age should be present" do
     @course.min_age = nil
     assert_not @course.valid?
  end

  test "min age should be >= 0" do
     @course.min_age = -1
     assert_not @course.valid?
  end

  test "min age should be <= 100" do
     @course.min_age = 101
     assert_not @course.valid?
  end

  test "min age should not be letters" do
    @course.min_age = "aa"
    assert_not @course.valid?
  end

  #############################################################################
  # max age
  #############################################################################

  test "max age should be present" do
     @course.max_age = nil
     assert_not @course.valid?
  end

  test "max age should be >= 0" do
     @course.max_age = -1
     assert_not @course.valid?
  end

  test "max age should be <= 100" do
     @course.max_age = 101
     assert_not @course.valid?
  end
  
  test "max age should not be letters" do
    @course.max_age = "aa"
    assert_not @course.valid?
  end

  #############################################################################
  # age range
  #############################################################################

  test "min age should be less than max age" do
    @course.min_age = @course.max_age
    assert_not @course.valid?
  end

  #############################################################################
  # min students
  #############################################################################

  test "min students should be present" do
     @course.min_students = nil
     assert_not @course.valid?
  end

  test "min students should be >= 0" do
     @course.min_students = -1
     assert_not @course.valid?
  end

  test "min students should be <= 100" do
     @course.min_students = 101
     assert_not @course.valid?
  end

  test "min students should not be letters" do
    @course.min_students = "aa"
    assert_not @course.valid?
  end

  #############################################################################
  # max students
  #############################################################################

  test "max students should be present" do
     @course.max_students = nil
     assert_not @course.valid?
  end

  test "max students should be >= 0" do
     @course.max_students = -1
     assert_not @course.valid?
  end

  test "max students should be <= 100" do
     @course.max_students = 101
     assert_not @course.valid?
  end

  test "max students should not be letters" do
    @course.max_students = "aa"
    assert_not @course.valid?
  end

  #############################################################################
  # student range
  #############################################################################

  test "min students should be less than max students" do
    @course.min_students = @course.max_students
    assert_not @course.valid?
  end

  #############################################################################
  # fee
  #############################################################################

  test "fee should be present" do
    @course.fee = nil
    assert_not @course.valid?
  end

  test "fee should be >= 0" do
     @course.fee = -1
     assert_not @course.valid?
  end

  test "fee should be < 1000" do
     @course.fee = 1000
     assert_not @course.valid?
  end

  test "fee should not be letters" do
    @course.fee = "aa"
    assert_not @course.valid?
  end

  test "fee should allow decimal" do
     @course.fee = 10.5
     assert @course.valid?
  end

end
