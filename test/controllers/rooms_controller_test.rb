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
  # (there is no new/create route)
  #############################################################################

  #############################################################################
  # edit/update
  #############################################################################

  test "anonymous should not get edit" do
    get :edit, params: { id: @room.id }
    assert_redirected_to root_url
  end

  test "anonymous should not get update" do
    put :update, params: { id: @room.id, room: @room }
    assert_redirected_to root_url
  end

  test "user should not get edit" do
    sign_in @user
    get :edit, params: { id: @room.id }
    assert_redirected_to root_url
  end

  test "user should not get update" do
    sign_in @user
    put :update, params: { id: @room.id, room: @room.attributes }
    assert_redirected_to root_url
  end

  test "web team should get edit" do
    sign_in @web_team
    get :edit, params: { id: @room.id }
    assert_response :success
  end

  test "web team should get update" do
    sign_in @web_team
    put :update, params: { id: @room.id, room: @room.attributes }
    assert_redirected_to rooms_path
  end

  #############################################################################
  # destroy
  # (there is no destroy route)
  #############################################################################
end
