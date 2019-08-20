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
    post :create, params: { pronoun: @pronoun.attributes }
    assert_redirected_to root_url
  end

  test "user should get new" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "user should get create" do
    sign_in @user
    assert_difference('Pronoun.count', 1) do
      post :create, params: { pronoun: {preferred_pronouns: "a/b/c"} }
    end
    assert_redirected_to pronouns_path
  end

  test "web team should get new" do
    sign_in @web_team
    get :new
    assert_response :success
  end

  test "web team should get create" do
    sign_in @web_team
    assert_difference('Pronoun.count', 1) do
      post :create, params: { pronoun: {preferred_pronouns: "a/b/c"} }
    end
    assert_redirected_to pronouns_path
  end

  #############################################################################
  # edit/update
  #############################################################################

  test "anonymous should not get edit" do
    get :edit, params: { id: @pronoun.id }
    assert_redirected_to root_url
  end

  test "anonymous should not get update" do
    patch :update, params: { id: @pronoun.id, pronoun: @pronoun }
    assert_redirected_to root_url
  end

  test "user should not get edit" do
    sign_in @user
    get :edit, params: { id: @pronoun.id }
    assert_redirected_to root_url
  end

  test "user should not get update" do
    sign_in @user
    patch :update, params: { id: @pronoun.id, pronoun: @pronoun.attributes }
    assert_redirected_to root_url
  end

  test "web team should get edit" do
    sign_in @web_team
    get :edit, params: { id: @pronoun.id }
    assert_response :success
  end

  test "web team should get update" do
    sign_in @web_team
    patch :update, params: { id: @pronoun.id, pronoun: @pronoun.attributes }
    assert_redirected_to pronouns_url
  end

  #############################################################################
  # destroy
  #############################################################################

  test "anonymous should not get destroy" do
    delete :destroy, params: { id: @pronoun.id }
    assert_redirected_to root_url
  end

  test "user should not get destroy" do
    sign_in @user
    delete :destroy, params: { id: @pronoun.id }
    assert_redirected_to root_url
  end

  test "web team should get destroy" do
    sign_in @web_team
    # create a new pronoun to destroy so we know it has no people referencing it
    p = Pronoun.create(preferred_pronouns: "a/b/c")
    assert_difference 'Pronoun.count', -1 do
      delete :destroy, params: { id: p.id }
    end
    assert_redirected_to pronouns_url
  end
end
