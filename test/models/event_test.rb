require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @event = events(:week1)
  end
  
  test "should be valid" do
    assert @event.valid?
  end
  
  test "title should be present" do
    @event.title = nil
    assert_not @event.valid?
  end

  test "start_dt should be present" do
    @event.start_dt = nil
    assert_not @event.valid?
  end

  test "end_dt should be present" do
    @event.end_dt = nil
    assert_not @event.valid?
  end

  test "calendar_id should be present" do
    @event.calendar_id = nil
    assert_not @event.valid?
  end
  
  test "title should not be too short" do
     @event.title = "a" * 4
     assert_not @event.valid?
  end

  test "title should not be too long" do
     @event.title = "a" * 31
     assert_not @event.valid?
  end

  test "calendar_id should be a number" do
    @event.calendar_id = ""
    assert_not @event.valid?
  end
end
