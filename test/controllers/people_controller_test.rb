require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @web_team = users(:lj)
    @web_team.roles << roles(:web_team)
    @user = users(:js)
    @user.roles << roles(:user)
    @person = people(:membership1_person)
    @member = users(:membership1)
    @fall = cuco_sessions(:fall)
    @fall.families << @member.person.family
    travel_to @fall.start_date + 1
  end

  #############################################################################
  # index
  #############################################################################

  test "anonymous should not get index" do
    get :index, family_id: @person.family_id
    assert_redirected_to root_url
  end

  test "user should not get index" do
    sign_in @user
    get :index, family_id: @person.family_id
    assert_redirected_to root_url
  end

  test "member should not get index" do
    sign_in @member
    get :index, family_id: @person.family_id
    assert_redirected_to root_url
  end

  test "web_team should get index" do
    sign_in @web_team
    get :index, family_id: @person.family_id
    assert_response :success
  end

  #############################################################################
  # new/create
  #############################################################################

  test "anonymous should not get new" do
    get :new, family_id: @person.family_id
    assert_redirected_to root_url
  end

  test "anonymous should not get create" do
    post :create, family_id: @person.family_id
    assert_redirected_to root_url
  end

  test "user should get new" do
    sign_in @user
    get :new, family_id: @person.family_id
    assert_response :success
  end

  test "user should get create" do
    sign_in @user
    p = @person.dup
    p.first_name = "New"
    assert_difference('Person.count', 1) do
      post :create, family_id: p.family_id, person: p.attributes
    end
    assert_redirected_to family_person_path(p.family_id, assigns(:person))
  end

  test "member should get new" do
    sign_in @member
    get :new, family_id: @person.family_id
    assert_response :success
  end

  test "member should get create" do
    sign_in @member
    p = @person.dup
    p.first_name = "New"
    assert_difference('Person.count', 1) do
      post :create, family_id: p.family_id, person: p.attributes
    end
    assert_redirected_to family_person_path(p.family_id, assigns(:person))
  end

  test "web_team should get new" do
    sign_in @web_team
    get :new, family_id: @person.family_id
    assert_response :success
  end

  test "web_team should get create" do
    sign_in @web_team
    p = @person.dup
    p.first_name = "New"
    assert_difference('Person.count', 1) do
      post :create, family_id: p.family_id, person: p.attributes
    end
    assert_redirected_to family_person_path(p.family_id, assigns(:person))
  end
  
  test "missing test" do
    print "\nPeopleController should prevent people from messing with others' families\n"
  end
  
  #############################################################################
  # edit/update
  #############################################################################

  test "anonymous should not get edit" do
    get :edit, family_id: @person.family_id, id: @person.id
    assert_redirected_to root_url
  end

  test "anonymous should not get update" do
    patch :update, family_id: @person.family_id, id: @person.id, person: @person.attributes
    assert_redirected_to root_url
  end

  test "user should get edit" do
    sign_in @user
    get :edit, family_id: @person.family_id, id: @person.id
    assert_response :success
  end

  test "user should get update" do
    sign_in @user
    patch :update, family_id: @person.family_id, id: @person.id, person: @person.attributes
    assert_redirected_to family_person_path(@person.family_id, @person.id)
  end

  test "member should get edit" do
    sign_in @member
    get :edit, family_id: @person.family_id, id: @person.id
    assert_response :success
  end
  
  test "member should get update" do
    sign_in @member
    patch :update, family_id: @person.family_id, id: @person.id, person: @person.attributes
    assert_redirected_to family_person_path(@person.family_id, @person.id)
  end

  test "web_team should get edit" do
    sign_in @web_team
    get :edit, family_id: @person.family_id, id: @person.id
    assert_response :success
  end

  test "web_team should get update" do
    sign_in @web_team
    patch :update, family_id: @person.family_id, id: @person.id, person: @person.attributes
    assert_redirected_to family_person_path(@person.family_id, @person.id)
  end

  #############################################################################
  # destroy
  #############################################################################

  test "anonymous should not get destroy" do
    delete :destroy, family_id: @person.family_id, id: @person.id
    assert_redirected_to root_url
  end

  test "user should not get destroy" do
    sign_in @user
    delete :destroy, family_id: @person.family_id, id: @person.id
    assert_redirected_to root_url
  end

  test "member should not get destroy" do
    sign_in @member
    delete :destroy, family_id: @person.family_id, id: @person.id
    assert_redirected_to root_url
  end

  test "web team should get destroy" do
    sign_in @web_team
    family_id = @person.family_id
    assert_difference 'Person.count', -1 do
      delete :destroy, family_id: @person.family_id, id: @person.id
    end
    assert_redirected_to family_url(@person.family_id)
  end
  
  test "delete primary adult" do
    print "\nPeopleController should test deletion of primary adult\n"
  end

end
