require 'test_helper'

class CucoSessionsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    CucoSession.clear_caches

    @cuco_session = cuco_sessions(:winter)
    @family = families(:johnson)
    @user = users(:js)
    @user.roles << roles(:user)
    @kimberly = people(:kimberly)
    @user_without_fam = users(:new)
    @user_without_fam.roles << roles(:user)
    @web_team = users(:lj)
    @web_team.roles << roles(:web_team)
    @member = users(:membership1)
    @member.roles << roles(:user)
    @spring = cuco_sessions(:spring)
    @fall = cuco_sessions(:fall)
    @fall.families << @member.person.family
    travel_to @cuco_session.start_date + 1.day
  end

  #############################################################################
  # show open jobs
  #############################################################################

  test "anonymous should not get show open jobs" do
    get :show_open_jobs, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "user should not get show open jobs" do
    travel_to @fall.end_date.to_date + 1
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    get :show_open_jobs, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "former should not get show open jobs" do
    travel_to @fall.start_date.to_date + 1
    sign_in @user
    @user.person.family.cuco_sessions << @spring
    assert_equal ["user", "former"], @user.clearance_levels
    get :show_open_jobs, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "member should not get show open jobs" do
    travel_to @fall.start_date.to_date + 1
    sign_in @member
    assert_equal ["user", "member"], @member.clearance_levels
    get :show_open_jobs, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "paid should get show open jobs" do
    travel_to @fall.start_date.to_date - 1
    sign_in @member
    assert_equal ["user", "paid"], @member.clearance_levels
    get :show_open_jobs, cuco_session_id: @fall.id
    assert_response :success
  end

  test "web team should get show open jobs" do
    travel_to @fall.end_date.to_date + 1
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
    get :show_open_jobs, cuco_session_id: @fall.id
    assert_response :success
  end

  #############################################################################
  # show rosters
  #############################################################################

  test "anonymous should not get show rosters" do
    get :show_rosters, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "user should not get show rosters" do
    travel_to @fall.end_date.to_date + 1
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    get :show_rosters, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "former should not get show rosters" do
    travel_to @fall.start_date.to_date + 1
    sign_in @user
    @user.person.family.cuco_sessions << @spring
    assert_equal ["user", "former"], @user.clearance_levels
    get :show_rosters, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "member should get show rosters" do
    travel_to @fall.start_date.to_date + 1
    sign_in @member
    assert_equal ["user", "member"], @member.clearance_levels
    get :show_rosters, cuco_session_id: @fall.id
    assert_response :success
  end

  test "paid should get show rosters" do
    travel_to @fall.start_date.to_date - 1
    sign_in @member
    assert_equal ["user", "paid"], @member.clearance_levels
    get :show_rosters, cuco_session_id: @fall.id
    assert_response :success
  end

  test "web team should get show rosters" do
    travel_to @fall.end_date.to_date + 1
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
    get :show_rosters, cuco_session_id: @fall.id
    assert_response :success
  end

  #############################################################################
  # show all signups
  #############################################################################

  test "anonymous should not get show all signups" do
    get :show_all_signups, cuco_session_id: @fall.id
    assert_redirected_to root_url
    get :show_all_signups_first_name, cuco_session_id: @fall.id
    assert_redirected_to root_url
    get :show_all_signups_last_name, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "user should not get show all signups" do
    travel_to @fall.end_date.to_date + 1
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    get :show_all_signups, cuco_session_id: @fall.id
    assert_redirected_to root_url
    get :show_all_signups_first_name, cuco_session_id: @fall.id
    assert_redirected_to root_url
    get :show_all_signups_last_name, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "former should not get show all signups" do
    travel_to @fall.start_date.to_date + 1
    sign_in @user
    @user.person.family.cuco_sessions << @spring
    assert_equal ["user", "former"], @user.clearance_levels
    get :show_all_signups, cuco_session_id: @fall.id
    assert_redirected_to root_url
    get :show_all_signups_first_name, cuco_session_id: @fall.id
    assert_redirected_to root_url
    get :show_all_signups_last_name, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "member should not get show all signups" do
    travel_to @fall.start_date.to_date + 1
    sign_in @member
    assert_equal ["user", "member"], @member.clearance_levels
    get :show_all_signups, cuco_session_id: @fall.id
    assert_redirected_to root_url
    get :show_all_signups_first_name, cuco_session_id: @fall.id
    assert_redirected_to root_url
    get :show_all_signups_last_name, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "paid should not get show all signups" do
    travel_to @fall.start_date.to_date - 1
    sign_in @member
    assert_equal ["user", "paid"], @member.clearance_levels
    get :show_all_signups, cuco_session_id: @fall.id
    assert_redirected_to root_url
    get :show_all_signups_first_name, cuco_session_id: @fall.id
    assert_redirected_to root_url
    get :show_all_signups_last_name, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "volunteer coordinator should get show all signups" do
    travel_to @fall.start_date.to_date - 1
    sign_in @member
    @member.roles << Role.find_by(name: "volunteer_coordinator")
    assert_equal ["user", "volunteer_coordinator", "paid"], @member.clearance_levels
    get :show_all_signups, cuco_session_id: @fall.id
    assert_response :success
    get :show_all_signups_first_name, cuco_session_id: @fall.id
    assert_response :success
    get :show_all_signups_last_name, cuco_session_id: @fall.id
    assert_response :success
  end

  test "web team should get show all signups" do
    travel_to @fall.end_date.to_date + 1
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
    get :show_all_signups, cuco_session_id: @fall.id
    assert_response :success
    get :show_all_signups_first_name, cuco_session_id: @fall.id
    assert_response :success
    get :show_all_signups_last_name, cuco_session_id: @fall.id
    assert_response :success
  end

  #############################################################################
  # show volunteers
  #############################################################################

  test "anonymous should not get show volunteers" do
    get :show_volunteers, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "user should not get show volunteers" do
    travel_to @fall.end_date.to_date + 1
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    get :show_volunteers, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "former should not get show volunteers" do
    travel_to @fall.start_date.to_date + 1
    sign_in @user
    @user.person.family.cuco_sessions << @spring
    assert_equal ["user", "former"], @user.clearance_levels
    get :show_volunteers, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "member should not get show volunteers" do
    travel_to @fall.start_date.to_date + 1
    sign_in @member
    assert_equal ["user", "member"], @member.clearance_levels
    get :show_volunteers, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "paid should not get show volunteers" do
    travel_to @fall.start_date.to_date - 1
    sign_in @member
    assert_equal ["user", "paid"], @member.clearance_levels
    get :show_volunteers, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "volunteer coordinator should get show volunteers" do
    travel_to @fall.start_date.to_date - 1
    sign_in @member
    @member.roles << Role.find_by(name: "volunteer_coordinator")
    assert_equal ["user", "volunteer_coordinator", "paid"], @member.clearance_levels
    get :show_volunteers, cuco_session_id: @fall.id
    assert_response :success
  end

  test "web team should get show volunteers" do
    travel_to @fall.end_date.to_date + 1
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
    get :show_volunteers, cuco_session_id: @fall.id
    assert_response :success
  end

  #############################################################################
  # show away
  #############################################################################

  test "anonymous should not get show away" do
    get :show_away, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "user should not get show away" do
    travel_to @fall.end_date.to_date + 1
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    get :show_away, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "former should not get show away" do
    travel_to @fall.start_date.to_date + 1
    sign_in @user
    @user.person.family.cuco_sessions << @spring
    assert_equal ["user", "former"], @user.clearance_levels
    get :show_away, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "member should not get show away" do
    travel_to @fall.start_date.to_date + 1
    sign_in @member
    assert_equal ["user", "member"], @member.clearance_levels
    get :show_away, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "paid should not get show away" do
    travel_to @fall.start_date.to_date - 1
    sign_in @member
    assert_equal ["user", "paid"], @member.clearance_levels
    get :show_away, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "volunteer coordinator should get show away" do
    travel_to @fall.start_date.to_date - 1
    sign_in @member
    @member.roles << Role.find_by(name: "volunteer_coordinator")
    assert_equal ["user", "volunteer_coordinator", "paid"], @member.clearance_levels
    get :show_away, cuco_session_id: @fall.id
    assert_response :success
  end

  test "web team should get show away" do
    travel_to @fall.end_date.to_date + 1
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
    get :show_away, cuco_session_id: @fall.id
    assert_response :success
  end

  #############################################################################
  # show nametags
  #############################################################################

  test "anonymous should not get show nametags" do
    get :show_nametags, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "user should not get show nametags" do
    travel_to @fall.end_date.to_date + 1
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    get :show_nametags, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "former should not get show nametags" do
    travel_to @fall.start_date.to_date + 1
    sign_in @user
    @user.person.family.cuco_sessions << @spring
    assert_equal ["user", "former"], @user.clearance_levels
    get :show_nametags, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "member should not get show nametags" do
    travel_to @fall.start_date.to_date + 1
    sign_in @member
    assert_equal ["user", "member"], @member.clearance_levels
    get :show_nametags, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "paid should not get show nametags" do
    travel_to @fall.start_date.to_date - 1
    sign_in @member
    assert_equal ["user", "paid"], @member.clearance_levels
    get :show_nametags, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "volunteer coordinator should not get show nametags" do
    travel_to @fall.start_date.to_date - 1
    sign_in @member
    @member.roles << Role.find_by(name: "volunteer_coordinator")
    assert_equal ["user", "volunteer_coordinator", "paid"], @member.clearance_levels
    get :show_nametags, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "web team should get show nametags" do
    travel_to @fall.end_date.to_date + 1
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
    get :show_nametags, cuco_session_id: @fall.id
    assert_response :success
  end

  #############################################################################
  # show fees summary
  #############################################################################

  test "anonymous should not get show fees summary" do
    get :show_fees_summary, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "user should not get show fees summary" do
    travel_to @fall.end_date.to_date + 1
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    get :show_fees_summary, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "former should not get show fees summary" do
    travel_to @fall.start_date.to_date + 1
    sign_in @user
    @user.person.family.cuco_sessions << @spring
    assert_equal ["user", "former"], @user.clearance_levels
    get :show_fees_summary, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "member should not get show fees summary" do
    travel_to @fall.start_date.to_date + 1
    sign_in @member
    assert_equal ["user", "member"], @member.clearance_levels
    get :show_fees_summary, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "paid should not get show fees summary" do
    travel_to @fall.start_date.to_date - 1
    sign_in @member
    assert_equal ["user", "paid"], @member.clearance_levels
    get :show_fees_summary, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "volunteer coordinator should not get show fees summary" do
    travel_to @fall.start_date.to_date - 1
    sign_in @member
    @member.roles << Role.find_by(name: "volunteer_coordinator")
    assert_equal ["user", "volunteer_coordinator", "paid"], @member.clearance_levels
    get :show_fees_summary, cuco_session_id: @fall.id
    assert_redirected_to root_url
  end

  test "treasurer should not get show fees summary" do
    travel_to @fall.start_date.to_date - 1
    sign_in @member
    @member.roles << Role.find_by(name: "treasurer")
    assert_equal ["user", "treasurer", "paid"], @member.clearance_levels
    get :show_fees_summary, cuco_session_id: @fall.id
    assert_response :success
  end

  test "web team should get show fees summary" do
    travel_to @fall.end_date.to_date + 1
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
    get :show_fees_summary, cuco_session_id: @fall.id
    assert_response :success
  end
end
