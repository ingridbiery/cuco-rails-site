require 'test_helper'

class EventTypeTest < ActiveSupport::TestCase
  def setup
    @event_type = event_types(:et_courses)
  end
  
  test "should be valid" do
    assert @event_type.valid?
  end
  
  #############################################################################
  # name
  #############################################################################

  test "name should be present" do
    @event_type.name = nil
    assert_not @event_type.valid?
  end

  #############################################################################
  # display name
  #############################################################################

  test "display_name should be present" do
    @event_type.display_name = nil
    assert_not @event_type.valid?
  end

  #############################################################################
  # offsets
  #############################################################################

  test "start_date_offset should be present" do
    @event_type.start_date_offset = nil
    assert_not @event_type.valid?
  end

  test "start_date_offset should be an integer" do
    @event_type.start_date_offset = 10.3
    assert_not @event_type.valid?
  end

  test "end_date_offset should be present" do
    @event_type.end_date_offset = nil
    assert_not @event_type.valid?
  end

  test "end_date_offset should be an integer" do
    @event_type.end_date_offset = 10.3
    assert_not @event_type.valid?
  end

  #############################################################################
  # time
  #############################################################################

  test "start_time should be present" do
    @event_type.start_time = nil
    assert_not @event_type.valid?
  end

  test "end_time should be present" do
    @event_type.end_time = nil
    assert_not @event_type.valid?
  end

  #############################################################################
  # flags (boolean values are hard to test because of typecasting)
  #############################################################################
  
  test "members only should be present" do
    @event_type.members_only = nil
    assert_not @event_type.valid?
  end

  test "registration should be present" do
    @event_type.registration = nil
    assert_not @event_type.valid?
  end

end
