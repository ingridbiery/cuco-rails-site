require 'test_helper'

class FamiliesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    @cuco_session = cuco_sessions(:winter)
    @family = families(:johnson)
    @user = users(:js)
    @user.roles << roles(:user)
    @kimberly = people(:kimberly)
    @user_without_fam = users(:new)
    @user_without_fam.roles << roles(:user)
    @web_team = users(:lj)
    @web_team.roles << roles(:web_team)
    @member = users(:membership1)
    @fall = cuco_sessions(:fall)
    @fall.families << @member.person.family
    travel_to @cuco_session.start_date + 1.day
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

  test "member should get index" do
    sign_in @member
    travel_to @fall.start_date + 1.day
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
    assert_difference 'Family.count', 1 do
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

  test "user with family should get edit for own family but not primary" do
    sign_in @user
    get :edit, id: @user.person.family.id
    assert_select "select[id=family_primary_adult_id]", 0
    assert_response :success
  end

  test "user with family should get update for own family" do
    sign_in @user
    family = @user.person.family
    patch :update, id: family.id, family: family.attributes
    assert_redirected_to family_path(assigns(:family))
  end

  test "user with family should not get edit for someone else's family" do
    sign_in @user
    get :edit, id: @family.id
    assert_redirected_to families_url
  end
  
  test "user with family should not get update for someone else's family" do
    sign_in @user
    patch :update, id: @family.id, family: @family.attributes
    assert_redirected_to families_url
  end
  
  test "user without family should not get edit" do
    sign_in @user_without_fam
    get :edit, id: @family.id
    assert_redirected_to families_url
  end
  
  test "user without family should not get update" do
    sign_in @user_without_fam
    patch :update, id: @family.id, family: @family.attributes
    assert_redirected_to families_url
  end

  test "web team should get edit for any family with primary adult" do
    sign_in @web_team
    family = @user.person.family
    family.primary_adult_id = @user.person.id
    family.save
    get :edit, id: family.id
    assert_select "select[id=family_primary_adult_id]", 1
    assert_response :success
  end

  test "web team should get edit for any family without primary adult" do
    sign_in @web_team
    family = @user.person.family
    family.primary_adult_id = nil
    family.save
    get :edit, id: family.id
    assert_select "select[id=family_primary_adult_id]", 1
    assert_response :success
  end

  #############################################################################
  # destroy
  #############################################################################

  test "anonymous should not get destroy" do
    delete :destroy, :id => @family.id
    assert_redirected_to root_url
  end

  test "user with family should not get destroy for own family" do
    sign_in @user
    delete :destroy, :id => @user.person.family.id
    assert_redirected_to root_url
  end

  test "user with family should not get destroy for someone else's family" do
    sign_in @user
    delete :destroy, :id => @family.id
    assert_redirected_to root_url
  end
  
  test "user without family should not get destroy" do
    sign_in @user_without_fam
    delete :destroy, :id => @family.id
    assert_redirected_to root_url
  end

  test "web team should get destroy" do
    sign_in @web_team
    assert_difference 'Family.count', -1 do
      delete :destroy, :id => @user.person.family.id
    end
    assert_redirected_to families_url
  end

end
