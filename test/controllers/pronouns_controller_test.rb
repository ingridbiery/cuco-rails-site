require 'test_helper'

class PronounsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @pronoun = pronouns(:they)
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
    assert_redirected_to new_user_session_url
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
    assert_redirected_to new_user_session_url
  end

  test "anonymous should not get create" do
    put :create, pronoun: @pronoun.attributes
    assert_redirected_to new_user_session_url
  end

  test "user should get new" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "user should get create" do
    sign_in @user
    assert_difference('Pronoun.count', 1) do
      put :create, pronoun: {preferred_pronouns: "a/b/c"}
    end
    assert_redirected_to pronouns_path
  end

  test "web team should get new" do
    sign_in @web_team
    get :new
    assert_response :success
  end

  #############################################################################
  # edit/update
  #############################################################################

  test "anonymous should not get edit" do
    get :edit, id: @pronoun.id
    assert_redirected_to new_user_session_url
  end

  test "anonymous should not get update" do
    put :update, id: @pronoun.id, pronoun: @pronoun
    assert_redirected_to new_user_session_url
  end

  test "user should get edit" do
    sign_in @user
    get :edit, id: @pronoun.id
    assert_response :success
  end

  test "user should get update" do
    sign_in @user
    put :update, id: @pronoun.id, pronoun: @pronoun.attributes
    assert_redirected_to pronouns_path
  end

  #############################################################################
  # destroy
  #############################################################################

  test "anonymous should not get destroy" do
    delete :destroy, :id => @pronoun.id
    assert_redirected_to new_user_session_url
  end

  test "user should not get destroy" do
    sign_in @user
    assert_difference('Pronoun.count', -1) do
      delete :destroy, :id => @pronoun.id
    end

    assert_redirected_to pronouns_path
  end
end
