require 'test_helper'

class PeriodsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @period = periods(:first)
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

  test "user should not get index" do
    sign_in @user
    get :index
    assert_redirected_to root_url
  end

  test "web_team should get index" do
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
    put :create, period: @period.attributes
    assert_redirected_to root_url
  end

  test "user should not get new" do
    sign_in @user
    get :new
    assert_redirected_to root_url
  end

  test "user should not get create" do
    sign_in @user
    put :create, period: {name:"test", start_time: "00:00:00", end_time: "00:00:00"}
    assert_redirected_to root_url
  end

  test "web_team should get create" do
    sign_in @web_team
    assert_difference('Period.count', 1) do
      put :create, period: {name:"test", start_time: "00:00:00", end_time: "00:00:00"}
    end
    assert_redirected_to periods_path
  end

  test "web_team should get new" do
    sign_in @web_team
    get :new
    assert_response :success
  end

  #############################################################################
  # edit/update
  #############################################################################

  test "anonymous should not get edit" do
    get :edit, id: @period.id
    assert_redirected_to root_url
  end

  test "anonymous should not get update" do
    put :update, id: @period.id, period: @period
    assert_redirected_to root_url
  end

  test "user should not get edit" do
    sign_in @user
    get :edit, id:@period.id
    assert_redirected_to root_url
  end

  test "user should not get update" do
    sign_in @user
    put :update, id: @period.id, period: @period.attributes
    assert_redirected_to root_url
  end

  test "web team should get edit" do
    sign_in @web_team
    get :edit, id: @period.id
    assert_response :success
  end

  test "web team should get update" do
    sign_in @web_team
    put :update, id: @period.id, period: @period.attributes
    assert_redirected_to periods_path
  end

  #############################################################################
  # destroy
  #############################################################################

  test "anonymous should not get destroy" do
    delete :destroy, :id => @period.id
    assert_redirected_to root_url
  end

  test "user should not get destroy" do
    sign_in @user
    delete :destroy, :id => @period.id
    assert_redirected_to root_url
  end

end
