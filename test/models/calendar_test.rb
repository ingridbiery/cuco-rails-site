require 'test_helper'

class CalendarTest < ActiveSupport::TestCase
  def setup
    @calendar = calendars(:one)
  end
  
  test "should be valid" do
    assert @calendar.valid?
  end
  
  test "google_id should be present" do
    @calendar.google_id = nil
    assert_not @calendar.valid?
  end

  test "cuco_session_id should be present" do
    @calendar.cuco_session_id = nil
    assert_not @calendar.valid?
  end

  test "members_only should be present" do
    @calendar.members_only = nil
    assert_not @calendar.valid?
  end
  
  test "cuco_session_id should be a number" do
     @calendar.cuco_session_id = "a"
     assert_not @calendar.valid?
   end

  test "members_only should be boolean" do
    @calendar.members_only = nil
    assert_not @calendar.valid?
  end

  test "calendar_id should be unique" do
    duplicate_calendar = @calendar.dup
    @calendar.save
    assert_not duplicate_calendar.valid?
  end
end
