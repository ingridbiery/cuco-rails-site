require 'test_helper'

class RoomsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @room = rooms(:gym)
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
    assert_redirected_to new_user_session_url
  end

  test "user should get index" do
    sign_in @user
    get :index
    assert_response :success
  end

  test "admin should get index" do
    sign_in @admin
    get :index
    assert_response :success
  end

  #############################################################################
  # new/create
  #############################################################################

  test "anonymous should not get new" do
    get :new
    assert_redirected_to new_user_session_url
  end

  test "anonymous should not get create" do
    put :create, room: @room.attributes
    assert_redirected_to new_user_session_url
  end

  test "user should get new" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "user should get create" do
    sign_in @user
    assert_difference('Room.count', 1) do
      put :create, room: {name: "new name"}
    end
    assert_redirected_to rooms_path
  end

  test "admin should get new" do
    sign_in @admin
    get :new
    assert_response :success
  end

  #############################################################################
  # edit/update
  #############################################################################

  test "anonymous should not get edit" do
    get :edit, id: @room.id
    assert_redirected_to new_user_session_url
  end

  test "anonymous should not get update" do
    put :update, id: @room.id, room: @room
    assert_redirected_to new_user_session_url
  end

  test "user should get edit" do
    sign_in @user
    get :edit, id: @room.id
    assert_response :success
  end

  test "user should get update" do
    sign_in @user
    put :update, id: @room.id, room: @room.attributes
    assert_redirected_to rooms_path
  end

  #############################################################################
  # destroy
  #############################################################################

  test "anonymous should not get destroy" do
    delete :destroy, :id => @room.id
    assert_redirected_to new_user_session_url
  end

  test "user should not get destroy" do
    sign_in @user
    assert_difference('Room.count', -1) do
      delete :destroy, :id => @room.id
    end

    assert_redirected_to rooms_path
  end

end
