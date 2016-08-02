require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @event = events(:week1)

    # complex event handling
    # sessions
    @winter = cuco_sessions(:winter)
    @spring = cuco_sessions(:spring)
    @fall = cuco_sessions(:fall)
    
    # member
    @member = users(:lj)
    @member.person.family.cuco_sessions << @spring
    @member.person.family.cuco_sessions << @fall

    # former member
    @former = users(:js)
    @former.person.family.cuco_sessions << @winter
    
    @course_offering = events(:course_offering)
    # @todo put in other events
  end
  
  test "should be valid" do
    assert @event.valid?
  end
  
  test "name should be present" do
    @event.name = nil
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
  
  test "next event should be course offering for member" do
    travel_to @course_offering.start_dt - 1
    assert_equal Dates.next_event(@member), @course_offering
  end
  
  # @todo put in other tests on next event
end
