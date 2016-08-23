require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  def setup
    @course = courses(:one)
  end

  test "should be valid" do
    assert @course.valid?
  end

#### TITLE ####

  test "title should be present" do
   @course.title = nil
   assert_not @course.valid?
  end

  ### We might want this but the seed file has a few with shorter titles
  # test "title should not be too short" do
  #   @course.title = "a" * 4
  #   assert_not @course.valid?
  # end

  test "title should not be too long" do
     @course.title = "a" * 101
     assert_not @course.valid?
  end

#### SHORT TITLE ####

  ### We might want this but the seed file has many with no short title
  # test "short title should be present" do
  #   @course.short_title = nil
  #   assert_not @course.valid?
  # end

  ### We might want this but the seed file has many that are longer
  # test "short title should not be too short" do
  #   @course.short_title = "a" * 2
  #   assert_not @course.valid?
  # end

  test "short title should not be too long" do
     @course.short_title = "a" * 31
     assert_not @course.valid?
  end

#### DESCRIPTION ####

  test "description should be present" do
    @course.description = nil
    assert_not @course.valid?
  end

#### AGE ####

  test "min age should not be too long" do
     @course.min_age = 1111
     assert_not @course.valid?
  end

  test "min age should not be letters" do
    @course.min_age = "aa"
    assert_not @course.valid?
  end

  test "max age should not be too long" do
     @course.max_age = 1111
     assert_not @course.valid?
  end
  
  test "max age should not be letters" do
    @course.max_age = "aa"
    assert_not @course.valid?
  end

  test "min age should be less than max age" do
    @course.min_age = @course.max_age
    assert_not @course.valid?
  end

#### STUDENTS ####

  test "min students should not be too long" do
     @course.min_students = 1111
     assert_not @course.valid?
  end

  test "min students should not be letters" do
    @course.min_students = "aa"
    assert_not @course.valid?
  end

  test "max students should not be too long" do
     @course.max_students = 1111
     assert_not @course.valid?
  end

  test "max students should not be letters" do
    @course.max_students = "aa"
    assert_not @course.valid?
  end

  test "min students should be less than max students" do
    @course.min_students = @course.max_students
    assert_not @course.valid?
  end

#### FEE ####

  test "fee should not be letters" do
    @course.fee = "aa"
    assert_not @course.valid?
  end

  test "fee should not be too long" do
     @course.fee = 1000
     assert_not @course.valid?
  end

end
