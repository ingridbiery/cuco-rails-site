require 'test_helper'

class CourseSignupsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    CucoSession.clear_caches

    # set up three sessions so we can test permissions for current & former members at different points in the
    # signup process
    @fall = cuco_sessions(:fall)
    @fall.dates.destroy
    d = Dates.create(cuco_session: @fall)
    d.calculate_dates
    @spring = cuco_sessions(:spring)
    d = Dates.create(cuco_session: @spring)
    d.calculate_dates
    @winter = cuco_sessions(:winter)
    d = Dates.create(cuco_session: @winter)
    d.calculate_dates
    
    @fall_course_offering = @fall.dates.events.find_by(event_type: EventType.find_by_name(:course_offering))
    @fall_member_reg = @fall.dates.events.find_by(event_type: EventType.find_by_name(:member_reg))

    @course_signup = course_signups(:one)
    @course = @course_signup.course
    @course.cuco_session = @fall
    @course.save
    @web_team = users(:lj)
    @web_team.roles << roles(:web_team)
    @user = users(:js)
    @user.roles << roles(:user)
    @fall_member = users(:membership1)
    @fall_member.roles << roles(:user)
    @spring_member = users(:membership2)
    @spring_member.roles << roles(:user)
    @winter_member = users(:membership3)
    @winter_member.roles << roles(:user)
    @fall.families << @fall_member.person.family
    @spring.families << @spring_member.person.family
    @winter.families << @winter_member.person.family
    @teacher = course_roles(:teacher)
    @student = course_roles(:student)
    
    # a person with no other signups
    @person = people(:emma)
  end

  #############################################################################
  # there is no index
  #############################################################################

  #############################################################################
  # new/create
  #############################################################################

  #############################################################################
  # student during course offering (not allowed)
  # member of winter is :former_member during fall course offering
  # member of spring is :member during fall course offering
  #############################################################################

  test "anonymous should not get new for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    new_test nil, :student
    assert_redirected_to root_url
  end

  test "anonymous should not get create for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    create_fail nil, :student
    assert_redirected_to root_url
  end

  test "user should not get new for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    new_test @user, :student
    assert_redirected_to root_url
  end

  test "user should not get create for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    create_fail @user, :student
    assert_redirected_to root_url
  end

  test "member should not get new for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    new_test @spring_member, :student
    assert_redirected_to root_url
  end

  test "member should not get create for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    create_fail @spring_member, :student
    assert_redirected_to root_url
  end

  test "former member should not get new for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    new_test @winter_member, :student
    assert_redirected_to root_url
  end

  test "former member should not get create for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    create_fail @winter_member, :student
    assert_redirected_to root_url
  end

  test "web team should get new for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    new_test @web_team, :student
    assert_response :success
  end

  test "web team should get create for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    create_success @web_team, :student
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end
  
  #############################################################################
  # teacher during course_offering (allowed for right role)
  # member of winter is :former_member during fall course offering
  # member of spring is :member during fall course offering
  #############################################################################

  test "anonymous should not get new for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    new_test nil, :teacher
    assert_redirected_to root_url
  end

  test "anonymous should not get create for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    create_fail nil, :teacher
    assert_redirected_to root_url
  end

  test "user should not get new for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    new_test @user, :teacher
    assert_redirected_to root_url
  end

  test "user should not get create for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    create_fail @user, :teacher
    assert_redirected_to root_url
  end

  test "member should get new for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    new_test @spring_member, :teacher
    assert_response :success
  end

  test "member should get create for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    create_success @spring_member, :teacher
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  test "former member should get new for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    new_test @winter_member, :teacher
    assert_response :success
  end

  test "former member should get create for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    create_success @winter_member, :teacher
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  test "web team should get new for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    new_test @web_team, :teacher
    assert_response :success
  end

  test "web team should get create for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    create_success @web_team, :teacher
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end
  
  #############################################################################
  # student after course offering but before registration (generally not allowed)
  # member of winter is :former_member during this time
  # member of spring is :member during this time
  #############################################################################

  test "anonymous should not get new for student between offering and registration" do
    travel_to @fall_member_reg.end_dt + 1.day
    new_test nil, :student
    assert_redirected_to root_url
  end

  test "anonymous should not get create for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    create_fail nil, :student
    assert_redirected_to root_url
  end

  test "user should not get new for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    new_test @user, :student
    assert_redirected_to root_url
  end

  test "user should not get create for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    create_fail @user, :student
    assert_redirected_to root_url
  end

  test "member should not get new for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    new_test @spring_member, :student
    assert_redirected_to root_url
  end

  test "member should not get create for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    create_fail @spring_member, :student
    assert_redirected_to root_url
  end

  test "former member should not get new for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    new_test @winter_member, :student
    assert_redirected_to root_url
  end

  test "former member should not get create for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    create_fail @winter_member, :student
    assert_redirected_to root_url
  end

  test "web team should get new for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    new_test @web_team, :student
    assert_response :success
  end

  test "web team should get create for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    create_success @web_team, :student
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  #############################################################################
  # teacher after course offering but before registration (generally not allowed)
  # member of winter is :former_member during this time
  # member of spring is :member during this time
  #############################################################################

  test "anonymous should not get new for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    new_test nil, :teacher
    assert_redirected_to root_url
  end

  test "anonymous should not get create for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    create_fail nil, :teacher
    assert_redirected_to root_url
  end

  test "user should not get new for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    new_test @user, :teacher
    assert_redirected_to root_url
  end

  test "user should not get create for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    create_fail @user, :teacher
    assert_redirected_to root_url
  end

  test "member should not get new for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    new_test @spring_member, :teacher
    assert_redirected_to root_url
  end

  test "member should not get create for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    create_fail @spring_member, :teacher
    assert_redirected_to root_url
  end

  test "former member should not get new for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    new_test @winter_member, :teacher
    assert_redirected_to root_url
  end

  test "former member should not get create for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    create_fail @winter_member, :teacher
    assert_redirected_to root_url
  end

  test "web team should get new for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    new_test @web_team, :teacher
    assert_response :success
  end

  test "web team should get create for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    create_success @web_team, :teacher
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end
  
  #############################################################################
  # student during registration (allowed for certain users)
  # member of winter is :former_member during this time
  # member of fall is :member during this time
  #############################################################################

  test "anonymous should not get new for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    new_test nil, :student
    assert_redirected_to root_url
  end

  test "anonymous should not get create for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    create_fail nil, :student
    assert_redirected_to root_url
  end

  test "user should not get new for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    new_test @user, :student
    assert_redirected_to root_url
  end

  test "user should not get create for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    create_fail @user, :student
    assert_redirected_to root_url
  end

  test "member should not get new for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    new_test @spring_member, :student
    assert_redirected_to root_url
  end

  test "member should not get create for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    create_fail @spring_member, :student
    assert_redirected_to root_url
  end

  test "paid should get new for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    new_test @fall_member, :student
    assert_response :success
  end

  test "paid should get create for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    create_success @fall_member, :student
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  test "former member should not get new for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    new_test @winter_member, :student
    assert_redirected_to root_url
  end

  test "former member should not get create for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    create_fail @winter_member, :student
    assert_redirected_to root_url
  end

  test "web team should get new for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    new_test @web_team, :student
    assert_response :success
  end

  test "web team should get create for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    create_success @web_team, :student
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  #############################################################################
  # teacher during registration (allowed for certain users)
  # member of winter is :former_member during this time
  # member of spring is :member during this time
  #############################################################################

  test "anonymous should not get new for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    new_test nil, :teacher
    assert_redirected_to root_url
  end

  test "anonymous should not get create for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    create_fail nil, :teacher
    assert_redirected_to root_url
  end

  test "user should not get new for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    new_test @user, :teacher
    assert_redirected_to root_url
  end

  test "user should not get create for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    create_fail @user, :teacher
    assert_redirected_to root_url
  end

  test "member should not get new for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    new_test @spring_member, :teacher
    assert_redirected_to root_url
  end

  test "member should not get create for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    create_fail @spring_member, :teacher
    assert_redirected_to root_url
  end

  test "paid should get new for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    new_test @fall_member, :teacher
    assert_response :success
  end

  test "paid should get create for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    create_success @fall_member, :teacher
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  test "former member should not get new for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    new_test @winter_member, :teacher
    assert_redirected_to root_url
  end

  test "former member should not get create for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    create_fail @winter_member, :teacher
    assert_redirected_to root_url
  end

  test "web team should get new for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    new_test @web_team, :teacher
    assert_response :success
  end

  test "web team should get create for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    create_success @web_team, :teacher
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  #############################################################################
  # edit/update
  #############################################################################

  #############################################################################
  # student during course offering (not allowed)
  # member of winter is :former_member during fall course offering
  # member of spring is :member during fall course offering
  #############################################################################

  test "anonymous should not get edit for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    edit_test nil, :student, @person
    assert_redirected_to root_url
  end

  test "anonymous should not get update for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    update_test nil, :student, @person
    assert_redirected_to root_url
  end

  test "user should not get edit for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    edit_test @user, :student, @user.person
    assert_redirected_to root_url
  end

  test "user should not get update for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    update_test @user, :student, @user.person
    assert_redirected_to root_url
  end

  test "member should not get edit for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    edit_test @spring_member, :student, @spring_member.person
    assert_redirected_to root_url
  end

  test "member should not get update for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    update_test @spring_member, :student, @spring_member.person
    assert_redirected_to root_url
  end

  test "former member should not get edit for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    edit_test @winter_member, :student, @winter_member.person
    assert_redirected_to root_url
  end

  test "former member should not get update for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    update_test @winter_member, :student, @winter_member.person
    assert_redirected_to root_url
  end

  test "web team should get edit for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    edit_test @web_team, :student, @web_team.person
    assert_response :success
  end

  test "web team should get update for student during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    update_test @web_team, :student, @web_team.person
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end
  
  #############################################################################
  # teacher during course_offering (generally not allowed)
  # member of winter is :former_member during fall course offering
  # member of spring is :member during fall course offering
  #############################################################################

  test "anonymous should not get edit for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    edit_test nil, :teacher, @person
    assert_redirected_to root_url
  end

  test "anonymous should not get update for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    update_test nil, :teacher, @person
    assert_redirected_to root_url
  end

  test "user should not get edit for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    edit_test @user, :teacher, @user.person
    assert_redirected_to root_url
  end

  test "user should not get update for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    update_test @user, :teacher, @user.person
    assert_redirected_to root_url
  end

  test "member should not get edit for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    edit_test @spring_member, :teacher, @spring_member.person
    assert_redirected_to root_url
  end

  test "member should not get update for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    update_test @spring_member, :teacher, @spring_member.person
    assert_redirected_to root_url
  end

  test "former member should not get edit for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    edit_test @winter_member, :teacher, @winter_member.person
    assert_redirected_to root_url
  end

  test "former member should not get update for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    update_test @winter_member, :teacher, @winter_member.person
    assert_redirected_to root_url
  end

  test "web team should get edit for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    edit_test @web_team, :teacher, @web_team.person
    assert_response :success
  end

  test "web team should get update for teacher during course offering" do
    travel_to @fall_course_offering.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    update_test @web_team, :teacher, @web_team.person
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end
  
  #############################################################################
  # student after course offering but before registration (generally not allowed)
  # member of winter is :former_member during this time
  # member of spring is :member during this time
  #############################################################################

  test "anonymous should not get edit for student between offering and registration" do
    travel_to @fall_member_reg.end_dt + 1.day
    edit_test nil, :student, @person
    assert_redirected_to root_url
  end

  test "anonymous should not get update for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    update_test nil, :student, @person
    assert_redirected_to root_url
  end

  test "user should not get edit for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    edit_test @user, :student, @user.person
    assert_redirected_to root_url
  end

  test "user should not get update for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    update_test @user, :student, @user.person
    assert_redirected_to root_url
  end

  test "member should not get edit for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    edit_test @spring_member, :student, @spring_member.person
    assert_redirected_to root_url
  end

  test "member should not get update for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    update_test @spring_member, :student, @spring_member.person
    assert_redirected_to root_url
  end

  test "former member should not get edit for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    edit_test @winter_member, :student, @winter_member.person
    assert_redirected_to root_url
  end

  test "former member should not get update for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    update_test @winter_member, :student, @winter_member.person
    assert_redirected_to root_url
  end

  test "web team should get edit for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    edit_test @web_team, :student, @web_team.person
    assert_response :success
  end

  test "web team should get update for student between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    update_test @web_team, :student, @web_team.person
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  #############################################################################
  # teacher after course offering but before registration (generally not allowed)
  # member of winter is :former_member during this time
  # member of spring is :member during this time
  #############################################################################

  test "anonymous should not get edit for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    edit_test nil, :teacher, @person
    assert_redirected_to root_url
  end

  test "anonymous should not get update for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    update_test nil, :teacher, @person
    assert_redirected_to root_url
  end

  test "user should not get edit for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    edit_test @user, :teacher, @user.person
    assert_redirected_to root_url
  end

  test "user should not get update for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    update_test @user, :teacher, @user.person
    assert_redirected_to root_url
  end

  test "member should not get edit for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    edit_test @spring_member, :teacher, @spring_member.person
    assert_redirected_to root_url
  end

  test "member should not get update for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    update_test @spring_member, :teacher, @spring_member.person
    assert_redirected_to root_url
  end

  test "former member should not get edit for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    edit_test @winter_member, :teacher, @winter_member.person
    assert_redirected_to root_url
  end

  test "former member should not get update for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    update_test @winter_member, :teacher, @winter_member.person
    assert_redirected_to root_url
  end

  test "web team should get edit for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    edit_test @web_team, :teacher, @web_team.person
    assert_response :success
  end

  test "web team should get update for teacher between offering and registration" do
    travel_to @fall_course_offering.end_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    update_test @web_team, :teacher, @web_team.person
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end
  
  #############################################################################
  # student during registration (allowed for certain users)
  # member of spring is :former_member during this time
  # member of winter is :member during this time
  #############################################################################

  test "anonymous should not get edit for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    edit_test nil, :student, @person
    assert_redirected_to root_url
  end

  test "anonymous should not get update for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    update_test nil, :student, @person
    assert_redirected_to root_url
  end

  test "user should not get edit for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    edit_test @user, :student, @user.person
    assert_redirected_to root_url
  end

  test "user should not get update for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    update_test @user, :student, @user.person
    assert_redirected_to root_url
  end

  test "member should not get edit for student in own family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    edit_test @spring_member, :student, @spring_member.person
    assert_redirected_to root_url
  end

  test "member should not get update for student in own family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    update_test @spring_member, :student, @spring_member.person
    assert_redirected_to root_url
  end

  test "member should not get edit for student in other family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    edit_test @spring_member, :student, @fall_member.person
    assert_redirected_to root_url
  end

  test "member should not get update for student in other family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    update_test @spring_member, :student, @fall_member.person
    assert_redirected_to root_url
  end

  test "paid should get edit for student in own family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    edit_test @fall_member, :student, @fall_member.person
    assert_response :success
  end

  test "paid should get update for student in own family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    update_test @fall_member, :student, @fall_member.person
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  test "paid should not get edit for student in other family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    edit_test @fall_member, :student, @spring_member.person
    assert_redirected_to root_url
  end

  test "paid should not get update for student in other family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    update_test @fall_member, :student, @spring_member.person
    assert_redirected_to root_url
  end

  test "former member should not get edit for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    edit_test @winter_member, :student, @winter_member.person
    assert_redirected_to root_url
  end

  test "former member should not get update for student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    update_test @winter_member, :student, @winter_member.person
    assert_redirected_to root_url
  end

  test "web team should get edit for student in other family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    edit_test @web_team, :student, @spring_member.person
    assert_response :success
  end

  test "web team should get update for student in other family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    update_test @web_team, :student, @spring_member.person
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  #############################################################################
  # teacher during registration (allowed for certain users)
  # member of spring is :former_member during this time
  # member of fall is :member during this time
  #############################################################################

  test "anonymous should not get edit for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    edit_test nil, :teacher, @person
    assert_redirected_to root_url
  end

  test "anonymous should not get update for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    update_test nil, :teacher, @person
    assert_redirected_to root_url
  end

  test "user should not get edit for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    edit_test @user, :teacher, @user.person
    assert_redirected_to root_url
  end

  test "user should not get update for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    update_test @user, :teacher, @user.person
    assert_redirected_to root_url
  end

  test "member should not get edit for empty teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    edit_test @spring_member, :teacher, nil
    assert_redirected_to root_url
  end

  test "member should not get update for empty teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    update_test @spring_member, :teacher, nil
    assert_redirected_to root_url
  end

  test "member should not get edit for teacher in own family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    edit_test @spring_member, :teacher, @spring_member.person
    assert_redirected_to root_url
  end

  test "member should not get update for teacher in own family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    update_test @spring_member, :teacher, @spring_member.person
    assert_redirected_to root_url
  end

  test "member should not get edit for teacher in other family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    edit_test @spring_member, :teacher, @fall_member.person
    assert_redirected_to root_url
  end

  test "member should not get update for teacher in other family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    update_test @spring_member, :teacher, @fall_member.person
    assert_redirected_to root_url
  end

  test "paid should get edit for empty teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    edit_test @fall_member, :teacher, nil
    assert_response :success
  end

  test "paid should get update for empty teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    update_test @fall_member, :teacher, nil
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  test "paid should get edit for teacher in own family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    edit_test @fall_member, :teacher, @fall_member.person
    assert_response :success
  end

  test "paid should get update for teacher in own family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    update_test @fall_member, :teacher, @fall_member.person
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  test "paid should not get edit for teacher in other family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    edit_test @fall_member, :teacher, @winter_member.person
    assert_redirected_to root_url
  end

  test "paid should not get update for teacher in other family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    update_test @fall_member, :teacher, @spring_member.person
    assert_redirected_to root_url
  end

  test "former member should not get edit for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    edit_test @winter_member, :teacher, @winter_member.person
    assert_redirected_to root_url
  end

  test "former member should not get update for teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    update_test @winter_member, :teacher, @winter_member.person
    assert_redirected_to root_url
  end

  test "web team should get edit for empty teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    edit_test @web_team, :teacher, nil
    assert_response :success
  end

  test "web team should get update for empty teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    update_test @web_team, :teacher, nil
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  test "web team should get edit for teacher in own family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    edit_test @web_team, :teacher, @web_team.person
    assert_response :success
  end

  test "web team should get update for teacher in own family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    update_test @web_team, :teacher, @web_team.person
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  test "web team should get edit for teacher in other family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    edit_test @web_team, :teacher, @spring_member.person
    assert_response :success
  end

  test "web team should get update for teacher in other family during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    update_test @web_team, :teacher, @spring_member.person
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  #############################################################################
  # destroy
  #############################################################################

  #############################################################################
  # before registration time (generally not allowed)
  #############################################################################

  test "anonymous should not get destroy before registration" do
    travel_to @fall_member_reg.start_dt - 1.day
    destroy_fail nil, :student, @person
    assert_redirected_to root_url
  end

  test "user should not get destroy before registration" do
    travel_to @fall_member_reg.start_dt - 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    destroy_fail @user, :student, @user.person
    assert_redirected_to root_url
  end

  test "former member should not get destroy before registration" do
    travel_to @fall_member_reg.start_dt - 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    destroy_fail @winter_member, :student, @winter_member.person
    assert_redirected_to root_url
  end

  test "member should not get destroy before registration" do
    travel_to @fall_member_reg.start_dt - 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    destroy_fail @spring_member, :student, @spring_member.person
    assert_redirected_to root_url
  end

  test "web team should get destroy before registration" do
    travel_to @fall_member_reg.start_dt - 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    destroy_success @web_team, :student, @web_team.person
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end
  
  #############################################################################
  # during registration (allowed for certain users)
  #############################################################################

  test "anonymous should not get destroy during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    destroy_fail nil, :student, @person
    assert_redirected_to root_url
  end

  test "user should not get destroy during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    destroy_fail @user, :student, @user.person
    assert_redirected_to root_url
  end

  test "former member should not get destroy during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "former"], @winter_member.clearance_levels
    destroy_fail @winter_member, :student, @winter_member.person
    assert_redirected_to root_url
  end

  test "member should not get destroy for own family student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    destroy_fail @spring_member, :student, @spring_member.person
    assert_redirected_to root_url
  end

  test "member should not get destroy for own family teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "member"], @spring_member.clearance_levels
    destroy_fail @spring_member, :teacher, @spring_member.person
    assert_redirected_to root_url
  end

  test "paid should get destroy for own family student during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    destroy_success @fall_member, :student, @fall_member.person
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  test "paid should not get destroy for own family teacher during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_equal ["user", "paid"], @fall_member.clearance_levels
    destroy_fail @fall_member, :teacher, @fall_member.person
    assert_redirected_to root_url
  end

  test "web team should get destroy during registration" do
    travel_to @fall_member_reg.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    destroy_success @web_team, :student, @web_team.person
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  #############################################################################
  # HELPERS
  #############################################################################

  def new_test user, role_name
    sign_in user unless !user
    get :new, cuco_session_id: @fall.id, course_id: @course.id, role_name: role_name
  end

  def create_success user, role_name
    create_test user, role_name, 1
  end
  
  def create_fail user, role_name
    create_test user, role_name, 0
  end

  def create_test user, role_name, diff
    sign_in user unless !user
    s = @course_signup.dup
    s.person = @person
    s.course_role_id = get_role_id(role_name)
    assert_difference('CourseSignup.count', diff) do
      post :create, cuco_session_id: @fall.id, course_id: @course.id, course_signup: s.attributes
    end
  end
  
  def edit_test user, role_name, person
    sign_in user unless !user
    @course_signup.course_role_id = get_role_id(role_name)
    @course_signup.person = person
    @course_signup.save
    get :edit, cuco_session_id: @fall.id, course_id: @course.id, id: @course_signup.id
  end

  def update_test user, role_name, person
    sign_in user unless !user
    @course_signup.person = person
    @course_signup.course_role_id = get_role_id(role_name)
    @course_signup.save
    patch :update, cuco_session_id: @fall.id, course_id: @course.id, id: @course_signup.id, course_signup: @course_signup.attributes
  end

  def destroy_success user, role_name, person
    destroy_test user, role_name, person, -1
  end
  
  def destroy_fail user, role_name, person
    destroy_test user, role_name, person, 0
  end

  def destroy_test user, role_name, person, diff
    sign_in user unless !user
    @course_signup.person = person
    @course_signup.course_role_id = get_role_id(role_name)
    @course_signup.save
    assert_difference('CourseSignup.count', diff) do
      delete :destroy, cuco_session_id: @fall.id, course_id: @course.id, id: @course_signup.id
    end
  end

  def get_role_id role_name
    if (role_name == :teacher)
      @teacher.id
    else
      @student.id
    end      
  end
  
end
