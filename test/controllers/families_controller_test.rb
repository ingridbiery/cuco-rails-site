require 'test_helper'

class FamiliesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @family = families(:johnson)
    @user = users(:js)
    @user.roles << roles(:user)
    @kimberly = people(:kimberly)
    @user_without_fam = users(:new)
    @user_without_fam.roles << roles(:user)
    @web_team = users(:lj)
    @web_team.roles << roles(:web_team)
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
    assert_redirected_to root_path
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
    post :create, family: @family.attributes
    assert_redirected_to root_url
  end

  test "user without family should get new" do
    sign_in @user_without_fam
    get :new
    assert_response :success
  end

  test "user without family should get create" do
    sign_in @user_without_fam
    f = @family.dup
    f.name = "NEW NAME"
    family_attributes = f.attributes
    p = @kimberly.dup
    p.first_name = "NEW NAME"
    family_attributes[:person] = p.attributes
    assert_difference('Family.count', 1) do
      post :create, family: family_attributes
    end
  end

  test "user with family should not get new" do
    get :new
    assert_redirected_to root_url
  end

  test "user with family should not get create" do
    post :create, family: @family.attributes
    assert_redirected_to root_url
  end

  #############################################################################
  # edit/update
  #############################################################################

  test "anonymous should not get edit" do
    get :edit, id: @family.id
    assert_redirected_to root_url
  end

  test "anonymous should not get update" do
    patch :update, id: @family.id, family: @family
    assert_redirected_to root_url
  end

  test "user should not get edit" do
    sign_in @user
    get :edit, id: @family.id
    assert_redirected_to families_url
  end

  test "user should not get update" do
    sign_in @user
    patch :update, id: @family.id, family: @family.attributes
    assert_redirected_to families_url
  end

  #############################################################################
  # destroy
  #############################################################################

  test "anonymous should not get destroy" do
    delete :destroy, :id => @family.id
    assert_redirected_to root_url
  end

  test "user should not get destroy" do
    sign_in @user
    # create a new family to destroy so we know it has no users referencing it
    f = @family.dup
    f.name = "NEW NAME"
    f.save
    assert_difference 'Family.count', 0 do
      delete :destroy, :id => f.id
    end
    assert_redirected_to root_url
  end
end
