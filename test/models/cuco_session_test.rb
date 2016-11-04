require 'test_helper'

class CucoSessionTest < ActiveSupport::TestCase
  def setup
    @cuco_session = cuco_sessions(:fall)
    @winter = cuco_sessions(:winter)
    @spring = cuco_sessions(:spring)
    @fall = cuco_sessions(:fall)
  end
  
  test "should be valid" do
    assert @cuco_session.valid?
  end
  
  #############################################################################
  # name
  #############################################################################

  test "name should be present" do
    @cuco_session.name = "    "
    assert_not @cuco_session.valid?
  end

  test "name should not be too short" do
     @cuco_session.name = "a" * 4
     assert_not @cuco_session.valid?
   end

  test "name should not be too long" do
     @cuco_session.name = "a" * 31
     assert_not @cuco_session.valid?
  end

  test "name should be unique" do
    duplicate_cuco_session = @cuco_session.dup
    @cuco_session.save
    assert_not duplicate_cuco_session.valid?
  end
  
  #############################################################################
  # dates/events
  #############################################################################
  # trying to test for start_date and end_date presence
  # breaks cuco_sessions#valid_dates so we'll just skip that
  
  test "start date should be before end date" do
    @cuco_session.start_date = @cuco_session.end_date
    assert_not @cuco_session.valid?
  end
  
  test "current should return current session when there is one" do
    travel_to @fall.start_date.to_date + 1
    assert_equal @fall, CucoSession.current
  end

  test "current should return nil when there isn't one" do
    travel_to @fall.end_date.to_date + 1
    current = CucoSession.current
    assert_nil current
  end

  test "upcoming should return upcoming session when there is one" do
    travel_to @fall.start_date.to_date - 1
    assert_equal @fall, CucoSession.upcoming
  end

  test "upcoming should return nil when there isn't one" do
    travel_to @fall.start_date.to_date + 1
    upcoming_session = CucoSession.upcoming
    assert_nil upcoming_session
  end

  test "last should return last session when there is one" do
    travel_to @fall.start_date.to_date - 1
    assert_equal @spring, CucoSession.last
  end

  test "last should return current session when there is one" do
    travel_to @fall.start_date.to_date + 1
    assert_equal @fall, CucoSession.last
  end

  test "last should return nil when there isn't one" do
    travel_to @winter.start_date.to_date - 1
    last = CucoSession.last
    assert_nil last
  end
end
