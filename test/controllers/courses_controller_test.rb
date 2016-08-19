require 'test_helper'

class CoursesControllerTest < ActionController::TestCase

  include Devise::Test::ControllerHelpers

  def setup
    @course = courses(:one)
    @web_team = users(:lj)
    @web_team.roles << roles(:web_team)
    @user = users(:js)
    @user.roles << roles(:user)
  end

  #############################################################################
  # index
  #############################################################################

  test "anonymous should not get index" do
    get :index
    assert_redirected_to root_url
  end

  test "user should get index" do
    sign_in @user
    get :index
    assert_response :success
  end

  test "web team should get index" do
    sign_in @web_team
    get :index
    assert_response :success
  end

  #############################################################################
  # new/create
  #############################################################################

  test "anonymous should not get new" do
    get :new
    assert_redirected_to root_url
  end

  test "anonymous should not get create" do
    post :create, course: @course.attributes
    assert_redirected_to root_url
  end

  test "user should get new" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "user should get create" do
    sign_in @user
    assert_difference('Course.count', 1) do
      post :create, course: {title: "Test Course", description: "Some description here"}
    end
    assert_redirected_to courses_path
  end

  test "web team should get new" do
    sign_in @web_team
    get :new
    assert_response :success
  end

  test "web team should get create" do
    sign_in @web_team
    assert_difference('Course.count', 1) do
      post :create, course: {title: "Test Course", description: "Some description here"}
    end
    assert_redirected_to courses_path
  end

  #############################################################################
  # edit/update
  #############################################################################

  test "anonymous should not get edit" do
    get :edit, id: @course.id
    assert_redirected_to root_url
  end

  test "anonymous should not get update" do
    patch :update, id: @course.id, course: @course
    assert_redirected_to root_url
  end

  test "user should get edit" do
    sign_in @user
    get :edit, id: @course.id
    assert_response :success
  end

  test "user should get update" do
    sign_in @user
    patch :update, id: @course.id, course: @course.attributes
    assert_redirected_to courses_url
  end

  test "web team should get edit" do
    sign_in @web_team
    get :edit, id: @course.id
    assert_response :success
  end

  test "web team should get update" do
    sign_in @web_team
    patch :update, id: @course.id, course: @course.attributes
    assert_redirected_to courses_url
  end

  #############################################################################
  # destroy
  #############################################################################

  test "anonymous should not get destroy" do
    delete :destroy, :id => @course.id
    assert_redirected_to root_url
  end

  test "user should get destroy" do
    sign_in @user
    delete :destroy, :id => @course.id
    assert_redirected_to root_url
  end

  test "web team should get destroy" do
    sign_in @web_team
    assert_difference 'Course.count', -1 do
      delete :destroy, :id => p.id
    end
    assert_redirected_to courses_url
  end

end
