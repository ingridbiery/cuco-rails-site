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
    
    # new member
    @new = users(:new)
    
    # these sample events are all appropriate dates for fall session
    @course_offering = events(:course_offering)
    @schedule_posted = events(:schedule_posted)
    @member_reg = events(:member_reg)
    @former_reg = events(:former_reg)
    @new_reg = events(:new_reg)
    @fees_posted = events(:fees_posted)
    @fees_due = events(:fees_due)
    @week1 = events(:week1)
    @week2 = events(:week2)
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
  
  test "next event for course offering" do
    travel_to @course_offering.end_dt - 1
    assert_equal Dates.next_event(@member), @course_offering
    assert_equal Dates.next_event(@former), @course_offering
    assert_equal Dates.next_event(@new), @schedule_posted
    assert_equal Dates.next_event(nil), @schedule_posted
  end
  
  test "next event for schedule posted" do
    travel_to @schedule_posted.end_dt - 1
    assert_equal Dates.next_event(@member), @schedule_posted
    assert_equal Dates.next_event(@former), @schedule_posted
    assert_equal Dates.next_event(@new), @schedule_posted
    assert_equal Dates.next_event(nil), @schedule_posted
  end
  
  test "next event for reg" do
    travel_to @member_reg.end_dt - 1
    assert_equal Dates.next_event(@member), @member_reg
    assert_equal Dates.next_event(@former), @former_reg
    assert_equal Dates.next_event(@new), @new_reg
    assert_equal Dates.next_event(nil), @new_reg
  end

  test "next event for fees posted" do
    travel_to @fees_posted.end_dt - 1
    assert_equal Dates.next_event(@member), @fees_posted
    assert_equal Dates.next_event(@former), @fees_posted
    assert_equal Dates.next_event(@new), @fees_posted
    assert_equal Dates.next_event(nil), @fees_posted
  end

  test "next event for fees due" do
    travel_to @fees_due.end_dt - 1
    assert_equal Dates.next_event(@member), @fees_due
    assert_equal Dates.next_event(@former), @fees_due
    assert_equal Dates.next_event(@new), @fees_due
    assert_equal Dates.next_event(nil), @fees_due
  end

  test "next event for week1" do
    travel_to @week1.end_dt - 1
    assert_equal Dates.next_event(@member), @week1
    assert_equal Dates.next_event(@former), @week1
    assert_equal Dates.next_event(@new), @week1
    assert_equal Dates.next_event(nil), @week1
  end

  test "next event for week2" do
    travel_to @week2.end_dt - 1
    assert_equal Dates.next_event(@member), @week2
    assert_equal Dates.next_event(@former), @week2
    assert_equal Dates.next_event(@new), @week2
    assert_equal Dates.next_event(nil), @week2
  end
end
