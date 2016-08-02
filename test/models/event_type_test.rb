require 'test_helper'

class EventTypeTest < ActiveSupport::TestCase
  def setup
    @event_type = event_types(:et_courses)
  end
  
  test "should be valid" do
    assert @event_type.valid?
  end
  
  test "name should be present" do
    @event_type.name = nil
    assert_not @event_type.valid?
  end

end
