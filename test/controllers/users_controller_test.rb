require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  def setup
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
    get :show, id: @user.id
    assert_redirected_to root_url
  end

  test "user should get show for self" do
    sign_in @user
    get :show, id: @user.id
    assert_response :success
  end

  test "user should not get show for someone else" do
    sign_in @user
    get :show, id: @web_team.id
    assert_redirected_to root_path
  end
  
  #############################################################################
  # 
  #############################################################################

  test "missing" do
    print "UsersController should test new/create/edit/update/destroy"
  end
end
