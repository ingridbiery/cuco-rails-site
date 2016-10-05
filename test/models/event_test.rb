require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @event = events(:week1)
  end
  
  test "should be valid" do
    assert @event.valid?
  end
  
  #############################################################################
  # name
  #############################################################################

  test "name should be present" do
    @event.name = nil
    assert_not @event.valid?
  end

  #############################################################################
  # date/time
  #############################################################################

  test "end_dt should not be before start_dt" do
    @event.start_dt = @event.end_dt + 1.day
    assert_not @event.valid?
  end
end
