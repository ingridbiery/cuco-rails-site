require 'test_helper'

class RoomsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @room = rooms(:gym)
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
    put :create, room: @room.attributes
    assert_redirected_to root_url
  end

  test "user should not get new" do
    sign_in @user
    get :new
    assert_redirected_to root_url
  end

  test "user should not get create" do
    sign_in @user
    put :create, room: {name: "new name"}
    assert_redirected_to root_url
  end

  test "web team should get new" do
    sign_in @web_team
    get :new
    assert_response :success
  end

  test "web_team should get create" do
    sign_in @web_team
    assert_difference('Room.count', 1) do
      put :create, room: {name: "new name"}
    end
    assert_redirected_to rooms_path
  end
  
  #############################################################################
  # edit/update
  #############################################################################

  test "anonymous should not get edit" do
    get :edit, id: @room.id
    assert_redirected_to root_url
  end

  test "anonymous should not get update" do
    put :update, id: @room.id, room: @room
    assert_redirected_to root_url
  end

  test "user should not get edit" do
    sign_in @user
    get :edit, id: @room.id
    assert_redirected_to root_url
  end

  test "user should not get update" do
    sign_in @user
    put :update, id: @room.id, room: @room.attributes
    assert_redirected_to root_url
  end

  test "web team should get edit" do
    sign_in @web_team
    get :edit, id: @room.id
    assert_response :success
  end

  test "web team should get update" do
    sign_in @web_team
    put :update, id: @room.id, room: @room.attributes
    assert_redirected_to rooms_path
  end

  #############################################################################
  # destroy
  #############################################################################

  test "anonymous should not get destroy" do
    delete :destroy, :id => @room.id
    assert_redirected_to root_url
  end

  test "user should not get destroy" do
    sign_in @user
    delete :destroy, :id => @room.id
    assert_redirected_to root_url
  end

  test "web team should get destroy" do
    sign_in @web_team
    assert_difference('Room.count', -1) do
      delete :destroy, :id => @room.id
    end
    assert_redirected_to rooms_path

  end

end
