require 'test_helper'

class PeriodTest < ActiveSupport::TestCase

  def setup
    @period = periods(:first)
  end

  test "should be valid" do
    assert @period.valid?
  end

  #############################################################################
  # name
  #############################################################################

  test "name should be present" do
   @period.name = nil
   assert_not @period.valid?
  end

  test "name should be unique" do
   duplicate_period = @period.dup
   duplicate_period.name = @period.name.upcase
   assert_not duplicate_period.valid?
  end

  #############################################################################
  # start time
  #############################################################################

  test "start_time should be present" do
    @period.start_time = nil
    assert_not @period.valid?
  end

  test "start_time should be unique" do
    duplicate_period = @period.dup
    duplicate_period.start_time = @period.start_time
    assert_not duplicate_period.valid?
  end

  #############################################################################
  # end time
  #############################################################################

  test "end_time should be present" do
    @period.end_time = nil
    assert_not @period.valid?
  end

  test "end_time should be unique" do
    duplicate_period = @period.dup
    duplicate_period.end_time = @period.end_time
    assert_not duplicate_period.valid?
  end

end
