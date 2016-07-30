require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @event = events(:week1)
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
end
