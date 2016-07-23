require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  def setup
    @admin = users(:lj)
    @admin.roles << roles(:admin)
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

  test "admin should get index" do
    sign_in @admin
    get :index
    assert_response :success
  end

  #############################################################################
  # show
  #############################################################################

  test "anonymous should not get show" do
    get :show, id: @user.id
    assert_redirected_to new_user_session_url
  end

  test "user should get show for self" do
    sign_in @user
    get :show, id: @user.id
    assert_response :success
  end

  test "user should not get show for someone else" do
    sign_in @user
    get :show, id: @admin.id
    assert_redirected_to root_path
  end
end
