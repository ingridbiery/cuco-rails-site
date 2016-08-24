require 'test_helper'

class CoursesControllerTest < ActionController::TestCase

  include Devise::Test::ControllerHelpers

  def setup
    @course = courses(:one)
    @session = cuco_sessions(:winter)
    @web_team = users(:lj)
    @web_team.roles << roles(:web_team)
    @user = users(:js)
    @user.roles << roles(:user)
  end

  #############################################################################
  # index
  #############################################################################

  test "anonymous should not get index" do
    get :index, cuco_session_id: @session.id
    assert_redirected_to new_user_session_url
  end

  test "user should get index" do
    sign_in @user
    get :index, cuco_session_id: @session.id
    assert_response :success
  end

  test "web team should get index" do
    sign_in @web_team
    get :index, cuco_session_id: @session.id
    assert_response :success
  end

  #############################################################################
  # new/create
  #############################################################################

  test "anonymous should not get new" do
    get :new, cuco_session_id: @session.id
    assert_redirected_to new_user_session_url
  end

  test "anonymous should not get create" do
    post :create, cuco_session_id: @session.id, course: @course.attributes
    assert_redirected_to new_user_session_url
  end

  test "user should get new" do
    sign_in @user
    get :new, cuco_session_id: @session.id
    assert_response :success
  end

  test "user should get create" do
    sign_in @user
    c = @course.dup
    c.name = "NEW NAME"
    assert_difference('Course.count', 1) do
      post :create, cuco_session_id: @session.id, course: c.attributes
    end
    assert_response :redirect
  end

  test "web team should get new" do
    sign_in @web_team
    get :new, cuco_session_id: @session.id
    assert_response :success
  end

  test "web team should get create" do
    sign_in @web_team
    c = @course.dup
    c.name = "NEW NAME"
    assert_difference('Course.count', 1) do
      post :create, cuco_session_id: @session.id, course: c.attributes
    end
    assert_response :redirect
  end

  #############################################################################
  # edit/update
  #############################################################################

  test "anonymous should not get edit" do
    get :edit, cuco_session_id: @session.id, id: @course.id
    assert_redirected_to new_user_session_url
  end

  test "anonymous should not get update" do
    patch :update, cuco_session_id: @session.id, id: @course.id, course: @course
    assert_redirected_to new_user_session_url
  end

  test "user should get edit" do
    sign_in @user
    get :edit, cuco_session_id: @session.id, id: @course.id
    assert_response :success
  end

  test "user should get update" do
    sign_in @user
    patch :update, cuco_session_id: @session.id, id: @course.id, course: @course.attributes
    assert_response :redirect
  end

  test "web team should get edit" do
    sign_in @web_team
    get :edit, cuco_session_id: @session.id, id: @course.id
    assert_response :success
  end

  test "web team should get update" do
    sign_in @web_team
    patch :update, cuco_session_id: @session.id, id: @course.id, course: @course.attributes
    assert_response :redirect
  end

  #############################################################################
  # destroy
  #############################################################################

  test "anonymous should not get destroy" do
    delete :destroy, cuco_session_id: @session.id, id: @course.id
    assert_redirected_to new_user_session_url
  end

  test "user should get destroy" do
    sign_in @user
    delete :destroy, cuco_session_id: @session.id, id: @course.id
    assert_redirected_to cuco_session_courses_url
  end

  test "web team should get destroy" do
    sign_in @web_team
    assert_difference 'Course.count', -1 do
      delete :destroy, cuco_session_id: @session.id, id: @course.id
    end
    assert_redirected_to cuco_session_courses_url, cuco_session_id: @session_id
  end

end
