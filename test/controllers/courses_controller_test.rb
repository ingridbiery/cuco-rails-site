require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    # set up a session so we can test permissions for different users at different points in the process
    @fall = cuco_sessions(:fall)
    @fall.dates.destroy
    d = Dates.create(cuco_session: @fall)
    d.calculate_dates
    @course_offering = @fall.dates.events.find_by(event_type: EventType.find_by_name(:course_offering))
    @spring = cuco_sessions(:spring)
    @winter = cuco_sessions(:winter)

    @course = courses(:one)
    @web_team = users(:lj)
    @web_team.roles << roles(:web_team)
    @web_team.roles << roles(:user)
    @user = users(:js)
    @user.roles << roles(:user)
    @member = users(:membership1)
    @member.roles << roles(:user)
    @spring.families << @member.person.family
    @former = users(:membership2)
    @former.roles << roles(:user)
    @winter.families << @former.person.family
  end

  #############################################################################
  # index
  #############################################################################

  #############################################################################
  # during course offering
  #############################################################################

  test "anonymous should get index during course offering" do
    travel_to @course_offering.start_dt + 1.day
    get :index, cuco_session_id: @fall.id
    assert_response :success
  end

  test "user should get index during course offering" do
    travel_to @course_offering.start_dt + 1.day
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    get :index, cuco_session_id: @fall.id
    assert_response :success
  end

  test "member should get index during course offering" do
    travel_to @course_offering.start_dt + 1.day
    sign_in @member
    assert_equal ["user", "member"], @member.clearance_levels
    get :index, cuco_session_id: @fall.id
    assert_response :success
  end

  test "web team should get index during course offering" do
    travel_to @course_offering.start_dt + 1.day
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
    get :index, cuco_session_id: @fall.id
    assert_response :success
  end

  #############################################################################
  # after course offering
  #############################################################################

  test "anonymous should get index after course offering" do
    travel_to @course_offering.end_dt + 1.day
    get :index, cuco_session_id: @fall.id
    assert_response :success
  end

  test "user should get index after course offering" do
    travel_to @course_offering.end_dt + 1.day
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    get :index, cuco_session_id: @fall.id
    assert_response :success
  end

  test "member should get index after course offering" do
    travel_to @course_offering.end_dt + 1.day
    sign_in @member
    assert_equal ["user", "member"], @member.clearance_levels
    get :index, cuco_session_id: @fall.id
    assert_response :success
  end

  test "web team should get index after course offering" do
    travel_to @course_offering.end_dt + 1.day
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
    get :index, cuco_session_id: @fall.id
    assert_response :success
  end

  #############################################################################
  # new/create
  #############################################################################

  #############################################################################
  # during course offering
  #############################################################################

  test "anonymous should not get new during course offering" do
    travel_to @course_offering.start_dt + 1.day
    new_test nil
    assert_redirected_to root_url
  end

  test "anonymous should not get create during course offering" do
    travel_to @course_offering.start_dt + 1.day
    create_fail nil
    assert_redirected_to root_url
  end

  test "user should not get new during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    new_test @user
    assert_redirected_to root_url
  end

  test "user should not get create during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    create_fail @user
    assert_redirected_to root_url
  end

  test "former should get new during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    new_test @former
    assert_response :success
  end

  test "former should get create during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    create_success @former
    assert_redirected_to cuco_session_course_path(@fall, assigns(:course))
  end

  test "member should get new during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    new_test @member
    assert_response :success
  end

  test "member should get create during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    create_success @member    
    assert_redirected_to cuco_session_course_path(@fall, assigns(:course))
  end

  test "web team should get new during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    new_test @web_team
    assert_response :success
  end

  test "web team should get create during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    create_success @web_team
    assert_redirected_to cuco_session_course_path(@fall, assigns(:course))
  end

  #############################################################################
  # after course offering
  #############################################################################

  test "anonymous should not get new after course offering" do
    travel_to @course_offering.end_dt + 1.day
    new_test nil
    assert_redirected_to root_url
  end

  test "anonymous should not get create after course offering" do
    travel_to @course_offering.end_dt + 1.day
    create_fail nil
    assert_redirected_to root_url
  end

  test "user should not get new after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    new_test @user
    assert_redirected_to root_url
  end

  test "user should not get create after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    create_fail @user
    assert_redirected_to root_url
  end

  test "former should not get new after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    new_test @former
    assert_redirected_to root_url
  end

  test "former should not get create after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    create_fail @former
    assert_redirected_to root_url
  end

  test "member should not get new after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    new_test @member
    assert_redirected_to root_url
  end

  test "member should not get create after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    create_fail @member    
    assert_redirected_to root_url
  end

  test "web team should get new after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    new_test @web_team
    assert_response :success
  end

  test "web team should get create after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    create_success @web_team
    assert_redirected_to cuco_session_course_path(@fall, assigns(:course))
  end

  #############################################################################
  # edit/update
  #############################################################################

  #############################################################################
  # during course offering
  #############################################################################

  test "anonymous should not get edit during course offering" do
    travel_to @course_offering.start_dt + 1.day
    edit_test nil, @member
    assert_redirected_to root_url
  end

  test "anonymous should not get update during course offering" do
    travel_to @course_offering.start_dt + 1.day
    update_test nil, @member
    assert_redirected_to root_url
  end

  test "user should not get edit during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    edit_test @user, @user
    assert_redirected_to root_url
  end

  test "user should not get update during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    update_test @user, @user
    assert_redirected_to root_url
  end

  test "former should get edit of own course during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    edit_test @former, @former
    assert_response :success
  end

  test "former should get update of own course during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    update_test @former, @former
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  test "former should not get edit of someone else's course during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    edit_test @former, @user
    assert_redirected_to root_url
  end

  test "former should not get update of someone else's course during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    update_test @former, @user
    assert_redirected_to root_url
  end

  test "member should get edit of own course during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    edit_test @member, @member
    assert_response :success
  end

  test "member should get update of own course during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    update_test @member, @member
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  test "member should not get edit of someone else's course during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    edit_test @member, @user
    assert_redirected_to root_url
  end

  test "member should not get update of someone else's course during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    update_test @member, @user
    assert_redirected_to root_url
  end

  test "web team should get edit during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    edit_test @web_team, @member
    assert_response :success
  end

  test "web team should get update during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    update_test @web_team, @member
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  #############################################################################
  # after course offering
  #############################################################################

  test "anonymous should not get edit after course offering" do
    travel_to @course_offering.end_dt + 1.day
    edit_test nil, @member
    assert_redirected_to root_url
  end

  test "anonymous should not get update after course offering" do
    travel_to @course_offering.end_dt + 1.day
    update_test nil, @member
    assert_redirected_to root_url
  end

  test "user should not get edit after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    edit_test @user, @user
    assert_redirected_to root_url
  end

  test "user should not get update after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    update_test @user, @user
    assert_redirected_to root_url
  end

  test "former should not get edit of own course after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    edit_test @former, @former
    assert_redirected_to root_url
  end

  test "former should not get update of own course after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    update_test @former, @former
    assert_redirected_to root_url
  end

  test "former should not get edit of someone else's course after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    edit_test @former, @user
    assert_redirected_to root_url
  end

  test "former should not get update of someone else's course after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    update_test @former, @user
    assert_redirected_to root_url
  end

  test "member should not get edit of own course after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    edit_test @member, @member
    assert_redirected_to root_url
  end

  test "member should not get update of own course after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    update_test @member, @member
    assert_redirected_to root_url
  end

  test "member should not get edit of someone else's course after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    edit_test @member, @user
    assert_redirected_to root_url
  end

  test "member should not get update of someone else's course after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    update_test @member, @user
    assert_redirected_to root_url
  end

  test "web team should get edit after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    edit_test @web_team, @member
    assert_response :success
  end

  test "web team should get update after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    update_test @web_team, @member
    assert_redirected_to cuco_session_course_path(@fall, @course)
  end

  #############################################################################
  # destroy
  #############################################################################

  #############################################################################
  # during course offering
  #############################################################################

  test "anonymous should not get destroy during course offering" do
    travel_to @course_offering.start_dt + 1.day
    destroy_fail nil, @user
    assert_redirected_to root_url
  end

  test "user should not get destroy during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    destroy_fail @user, @user
    assert_redirected_to root_url
  end

  test "former should get destroy of own course during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    destroy_success @former, @former
    assert_redirected_to cuco_session_courses_url(@fall.id)
  end

  test "former should not get destroy of someone else's course during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    destroy_fail @former, @user
    assert_redirected_to root_url
  end

  test "member should get destroy of own course during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    destroy_success @member, @member
    assert_redirected_to cuco_session_courses_url(@fall.id)
  end

  test "member should not get destroy of someone else's course during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    destroy_fail @member, @user
    assert_redirected_to root_url
  end

  test "web team should get destroy during course offering" do
    travel_to @course_offering.start_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    destroy_success @web_team, @member
    assert_redirected_to cuco_session_courses_url(@fall.id)
  end
  
  #############################################################################
  # after course offering
  #############################################################################

  test "anonymous should not get destroy after course offering" do
    travel_to @course_offering.end_dt + 1.day
    destroy_fail nil, @user
    assert_redirected_to root_url
  end

  test "user should not get destroy after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "new"], @user.clearance_levels
    destroy_fail @user, @user
    assert_redirected_to root_url
  end

  test "former should not get destroy of own course after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    destroy_fail @former, @former
    assert_redirected_to root_url
  end

  test "former should not get destroy of someone else's course after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "former"], @former.clearance_levels
    destroy_fail @former, @user
    assert_redirected_to root_url
  end

  test "member should not get destroy of own course after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    destroy_fail @member, @member
    assert_redirected_to root_url
  end

  test "member should not get destroy of someone else's course after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_equal ["user", "member"], @member.clearance_levels
    destroy_fail @member, @user
    assert_redirected_to root_url
  end

  test "web team should get destroy after course offering" do
    travel_to @course_offering.end_dt + 1.day
    assert_includes @web_team.clearance_levels, "web_team"
    destroy_success @web_team, @member
    assert_redirected_to cuco_session_courses_url(@fall.id)
  end
  
  #############################################################################
  # HELPERS
  #############################################################################

  def new_test user
    sign_in user unless !user
    get :new, cuco_session_id: @fall.id
  end

  def create_success user
    create_test user, 1
  end
  
  def create_fail user
    create_test user, 0
  end

  def create_test user, diff
    sign_in user unless !user
    c = @course.dup
    c.name = "NEW NAME"
    c.created_by_id = user&.id
    assert_difference('Course.count', diff) do
      post :create, cuco_session_id: @course.cuco_session_id, course: c.attributes
    end
  end
  
  def edit_test user, course_owner
    sign_in user unless !user
    @course.created_by_id = course_owner.id
    @course.save
    get :edit, cuco_session_id: @course.cuco_session_id, id: @course.id
  end

  def update_test user, course_owner
    sign_in user unless !user
    @course.created_by_id = course_owner.id
    @course.save
    patch :update, cuco_session_id: @fall.id, id: @course.id, course: @course.attributes
  end

  def destroy_success user, course_owner
    destroy_test user, course_owner, -1
  end
  
  def destroy_fail user, course_owner
    destroy_test user, course_owner, 0
  end

  def destroy_test user, course_owner, diff
    sign_in user unless !user
    @course.created_by_id = course_owner.id
    @course.save
    assert_difference('Course.count', diff) do
      delete :destroy, cuco_session_id: @course.cuco_session_id, id: @course.id
    end
  end
end
