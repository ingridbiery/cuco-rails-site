require 'test_helper'

class DatesTest < ActiveSupport::TestCase
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
    
    # these sample events are all appropriate @fall for fall session
    @course_offering = events(:course_offering)
    @schedule_posted = events(:schedule_posted)
    @member_reg = events(:member_reg)
    @former_reg = events(:former_reg)
    @new_reg = events(:new_reg)
    @fees_posted = events(:fees_posted)
    @fees_due = events(:fees_due)
    @week1 = events(:week1)
    @week2 = events(:week2)
    @other = events(:other)
  end
  
  #############################################################################
  # missing events
  #############################################################################
  test "missing member registration" do
    @member_reg.destroy
    assert_not @fall.dates.has_required_events?
  end

  test "missing former member registration" do
    @former_reg.destroy
    assert_not @fall.dates.has_required_events?
  end

  test "missing new member registration" do
    @new_reg.destroy
    assert_not @fall.dates.has_required_events?
  end
  
  #############################################################################
  # duplicate events
  #############################################################################

  test "duplicate course offering error" do
    new_event = @course_offering.dup
    new_event.save
    assert_not @fall.dates.has_required_events?
  end

  test "duplicate schedule posted error" do
    new_event = @schedule_posted.dup
    new_event.save
    assert_not @fall.dates.has_required_events?
  end

  test "duplicate member registration error" do
    new_event = @member_reg.dup
    new_event.save
    assert_not @fall.dates.has_required_events?
  end

  test "duplicate former member registration error" do
    new_event = @former_reg.dup
    new_event.save
    assert_not @fall.dates.has_required_events?
  end

  test "duplicate new member registration error" do
    new_event = @new_reg.dup
    new_event.save
    assert_not @fall.dates.has_required_events?
  end

  test "duplicate fees posted error" do
    new_event = @fees_posted.dup
    new_event.save
    assert_not @fall.dates.has_required_events?
  end

  test "duplicate fees due error" do
    new_event = @fees_due.dup
    new_event.save
    assert_not @fall.dates.has_required_events?
  end

  test "duplicate courses ok" do
    new_event = @week1.dup
    new_event.save
    assert @fall.dates.has_required_events?
  end

  test "duplicate other ok" do
    new_event = @other.dup
    new_event.save
    assert @fall.dates.has_required_events?
  end

  #############################################################################
  # next event
  #############################################################################

  test "next event for course offering" do
    travel_to @course_offering.end_dt - 1
    assert_equal @fall.dates.next_event(@member), @course_offering
    assert_equal @fall.dates.next_event(@former), @course_offering
    assert_equal @fall.dates.next_event(@new), @schedule_posted
    assert_equal @fall.dates.next_event(nil), @schedule_posted
  end
  
  test "next event for schedule posted" do
    travel_to @schedule_posted.end_dt - 1
    assert_equal @fall.dates.next_event(@member), @schedule_posted
    assert_equal @fall.dates.next_event(@former), @schedule_posted
    assert_equal @fall.dates.next_event(@new), @schedule_posted
    assert_equal @fall.dates.next_event(nil), @schedule_posted
  end
  
  test "next event for reg" do
    travel_to @member_reg.end_dt - 1
    assert_equal @fall.dates.next_event(@member), @member_reg
    assert_equal @fall.dates.next_event(@former), @former_reg
    assert_equal @fall.dates.next_event(@new), @new_reg
    assert_equal @fall.dates.next_event(nil), @new_reg
  end

  test "next event for fees posted" do
    travel_to @fees_posted.end_dt - 1
    assert_equal @fall.dates.next_event(@member), @fees_posted
    assert_equal @fall.dates.next_event(@former), @fees_posted
    assert_equal @fall.dates.next_event(@new), @fees_posted
    assert_equal @fall.dates.next_event(nil), @fees_posted
  end

  test "next event for fees due" do
    travel_to @fees_due.end_dt - 1
    assert_equal @fall.dates.next_event(@member), @fees_due
    assert_equal @fall.dates.next_event(@former), @fees_due
    assert_equal @fall.dates.next_event(@new), @fees_due
    assert_equal @fall.dates.next_event(nil), @fees_due
  end

  test "next event for week1" do
    travel_to @week1.end_dt - 1
    assert_equal @fall.dates.next_event(@member), @week1
    assert_equal @fall.dates.next_event(@former), @week1
    assert_equal @fall.dates.next_event(@new), @week1
    assert_equal @fall.dates.next_event(nil), @week1
  end

  test "next event for week2" do
    travel_to @week2.end_dt - 1
    assert_equal @fall.dates.next_event(@member), @week2
    assert_equal @fall.dates.next_event(@former), @week2
    assert_equal @fall.dates.next_event(@new), @week2
    assert_equal @fall.dates.next_event(nil), @week2
  end
end
