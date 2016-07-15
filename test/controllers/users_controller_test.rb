require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    @user = users(:lj)
  end

  test "users index should fail when not logged in" do
    get :index
    assert_response 302
    assert_redirected_to new_user_session_path
  end
  
  test "users index when logged in" do
    sign_in @user
    get :index
    assert_response :success
  end
  
  test "user show should fail when not logged in" do
    get :show, id: @user.id
    assert_response 302
    assert_redirected_to new_user_session_path
  end
    
  test "user show when logged in" do
    sign_in @user
    get :show, id: @user.id
    assert_response :success
  end
  
  # there are other things in the controller that should be tested here
  
end
