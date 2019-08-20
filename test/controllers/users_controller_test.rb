require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  def setup
    CucoSession.clear_caches

    @web_team = users(:lj)
    @web_team.roles << roles(:web_team)
    @user = users(:js)
    @user.roles << roles(:user)
    
    @fall = cuco_sessions(:fall)
    @fall.dates.destroy
    d = Dates.create(cuco_session: @fall)
    d.calculate_dates
    @spring = cuco_sessions(:spring)
    d = Dates.create(cuco_session: @spring)
    d.calculate_dates
    @spring_signups = d.events.find_by(event_type: EventType.find_by_name("member_reg"))
    @winter = cuco_sessions(:winter)
    d = Dates.create(cuco_session: @winter)
    d.calculate_dates

    @fall_member = users(:membership1)
    @spring_member = users(:membership2)
    @winter_member = users(:membership3)
    @fall.families << @fall_member.person.family
    @spring.families << @spring_member.person.family
    @winter.families << @winter_member.person.family
  end

  #############################################################################
  # index
  #############################################################################

  test "anonymous should not get index" do
    get :index
    assert_redirected_to root_path
  end

  test "user should not get index" do
    sign_in @user
    get :index
    assert_redirected_to root_path
  end

  test "web team should get index" do
    sign_in @web_team
    get :index
    assert_response :success
  end

  #############################################################################
  # show
  #############################################################################

  test "anonymous should not get show" do
    get :show, params: { id: @user.id }
    assert_redirected_to root_url
  end

  test "user should get show for self" do
    sign_in @user
    get :show, params: { id: @user.id }
    assert_response :success
  end

  test "user should not get show for someone else" do
    sign_in @user
    get :show, params: { id: @web_team.id }
    assert_redirected_to root_path
  end
  
  #############################################################################
  # new/create/edit/update/destroy
  #############################################################################

  test "missing" do
    print "\nUsersController should test new/create/edit/update/destroy\n"
  end

  #############################################################################
  # membership during session
  #############################################################################

  test "during session user with no person is :new" do
    travel_to @fall.start_date + 1.day
    @fall_member.person = nil
    assert_equal :new, @fall_member.membership_status
  end

  test "during session member of no sessions is :new" do
    travel_to @fall.start_date + 1.day
    @fall_member.person.family.memberships.each do |membership|
      membership.destroy
    end
    assert_equal :new, @fall_member.membership_status
  end

  test "during session A with no next session, member of A is :member" do
    travel_to @fall.start_date + 1.day
    assert_equal :member, @fall_member.membership_status
  end

  test "during session A with next session B before B signups, member of A is :member" do
    travel_to @spring.start_date + 1.day
    assert_equal :member, @spring_member.membership_status
  end

  test "during session A with next session B during B signups, member of A but not B is :member" do
    travel_to @spring_signups.start_dt + 1.day
    assert_equal :member, @winter_member.membership_status
  end

  test "during session A with next session B during B signups, member of A and B is :paid" do
    travel_to @spring_signups.start_dt + 1.day
    @spring.families << @winter_member.person.family
    assert_equal :paid, @winter_member.membership_status
  end

  test "during session member of any previous session is :former" do
    travel_to @fall.start_date + 1.day
    assert_equal :former, @spring_member.membership_status
    assert_equal :former, @winter_member.membership_status
  end

  #############################################################################
  # membership after session before signups
  #############################################################################

  test "after session before signups user with no person is :new" do
    travel_to @spring.end_date + 1.day
    @spring_member.person = nil
    assert_equal :new, @spring_member.membership_status
  end

  test "after session before signups member of no sessions is :new" do
    travel_to @spring.end_date + 1.day
    @spring_member.person.family.memberships.each do |membership|
      membership.destroy
    end
    assert_equal :new, @spring_member.membership_status
  end

  test "after session before signups member of previous session is :member" do
    travel_to @spring.end_date + 1.day
    assert_equal :member, @spring_member.membership_status
  end

  test "after session before signups member of any earlier session is :former" do
    travel_to @spring.end_date + 1.day
    assert_equal :former, @winter_member.membership_status
  end

  #############################################################################
  # membership after session during signups
  #############################################################################

  test "after session during signups user with no person is :new" do
    travel_to @fall.dates.events.find_by(event_type_id: EventType.find_by(name: :new_reg)).start_dt + 1.day
    @spring_member.person = nil
    assert_equal :new, @spring_member.membership_status
  end

  test "after session during signups member of no sessions is :new" do
    travel_to @fall.dates.events.find_by(event_type_id: EventType.find_by(name: :new_reg)).start_dt + 1.day
    @spring_member.person.family.memberships.each do |membership|
      membership.destroy
    end
    assert_equal :new, @spring_member.membership_status
  end

  test "after session during signups member of previous session is :member" do
    travel_to @fall.dates.events.find_by(event_type_id: EventType.find_by(name: :new_reg)).start_dt + 1.day
    assert_equal :member, @spring_member.membership_status
  end

  test "after session during signups member of any earlier session is :former" do
    travel_to @fall.dates.events.find_by(event_type_id: EventType.find_by(name: :new_reg)).start_dt + 1.day
    assert_equal :former, @winter_member.membership_status
  end

  test "after session during signups member of next session is :paid" do
    travel_to @fall.dates.events.find_by(event_type_id: EventType.find_by(name: :new_reg)).start_dt + 1.day
    assert_equal :paid, @fall_member.membership_status
  end

  #############################################################################
  # membership after signups before next session
  #############################################################################

  test "after signups before next session user with no person is :new" do
    travel_to @fall.dates.events.find_by(event_type_id: EventType.find_by(name: :new_reg)).end_dt + 1.day
    @spring_member.person = nil
    assert_equal :new, @spring_member.membership_status
  end

  test "after signups before next session member of no sessions is :new" do
    travel_to @fall.dates.events.find_by(event_type_id: EventType.find_by(name: :new_reg)).end_dt + 1.day
    @spring_member.person.family.memberships.each do |membership|
      membership.destroy
    end
    assert_equal :new, @spring_member.membership_status
  end

  test "after signups before next session member of previous session is :member" do
    travel_to @fall.dates.events.find_by(event_type_id: EventType.find_by(name: :new_reg)).end_dt + 1.day
    assert_equal :member, @spring_member.membership_status
  end

  test "after signups before next session member of any earlier session is :former" do
    travel_to @fall.dates.events.find_by(event_type_id: EventType.find_by(name: :new_reg)).end_dt + 1.day
    assert_equal :former, @winter_member.membership_status
  end

  test "after signups before next session member of next session is :paid" do
    travel_to @fall.dates.events.find_by(event_type_id: EventType.find_by(name: :new_reg)).end_dt + 1.day
    assert_equal :paid, @fall_member.membership_status
  end

end
