require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  # numbers of events in yml file
  PUBLIC_EVENTS = 9
  ALL_EVENTS = 30

  def setup
    CucoSession.clear_caches

    @fall_member = users(:membership1)
    @fall_member.roles << roles(:user)
    @fall = cuco_sessions(:fall)
    @fall.families << @fall_member.person.family
  end

  test "anonymous should get public events" do
    get :show, start_date: "2016-08-01"
    assert_select "div[class=?]", "simple-calendar-event", count: PUBLIC_EVENTS
  end

  test "member should get all events" do
    travel_to @fall.start_date + 1.day
    sign_in @fall_member
    assert_equal ["user", "member"], @fall_member.clearance_levels
    get :show, start_date: "2016-08-01"
    assert_select "div[class=?]", "simple-calendar-event", count: ALL_EVENTS
  end
end
