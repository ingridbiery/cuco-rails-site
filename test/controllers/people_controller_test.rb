require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    CucoSession.clear_caches

    @web_team = users(:lj)
    @web_team.roles << roles(:web_team)
    @web_team.roles << roles(:user)
    @user = users(:js)
    @user.roles << roles(:user)
    @person = people(:membership1_person)
    @former = users(:membership2)
    @former.roles << roles(:user)
    @winter = cuco_sessions(:winter)
    @winter.families << @former.person.family
    @member = users(:membership1)
    @member.roles << roles(:user)
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

  test "new user should not get index" do
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    get :index, family_id: @person.family_id
    assert_redirected_to root_url
  end

  test "former should not get index" do
    sign_in @former
    assert_equal ["user", "former"], @former.clearance_levels
    get :index, family_id: @person.family_id
    assert_redirected_to root_url
  end

  test "member should not get index" do
    sign_in @member
    assert_equal ["user", "member"], @member.clearance_levels
    get :index, family_id: @person.family_id
    assert_redirected_to root_url
  end

  test "web_team should get index" do
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
    get :index, family_id: @person.family_id
    assert_response :success
  end

  #############################################################################
  # new/create
  #############################################################################

  test "anonymous should not get new" do
    new_test nil, @user.person.family
    assert_redirected_to root_url
  end

  test "anonymous should not get create" do
    create_failure nil, @user.person.family
    assert_redirected_to root_url
  end

  test "new user should get new in own family" do
    assert_equal ["user", "new"], @user.clearance_levels
    new_test @user, @user.person.family
    assert_response :success
  end

  test "new user should not get new in someone else's family" do
    new_test @user, @member.person.family
    assert_redirected_to families_url
  end

  test "new user should get create in own family" do
    assert_equal ["user", "new"], @user.clearance_levels
    create_success @user, @user.person.family
    assert_redirected_to family_person_path(@user.person.family.id, assigns(:person))
  end

  test "new user should not get create in someone else's family" do
    assert_equal ["user", "new"], @user.clearance_levels
    create_failure @user, @former.person.family
    assert_redirected_to families_url
  end

  test "former should get new in own family" do
    assert_equal ["user", "former"], @former.clearance_levels
    new_test @former, @former.person.family
    assert_response :success
  end

  test "former should not get new in someone else's family" do
    assert_equal ["user", "former"], @former.clearance_levels
    new_test @former, @member.person.family
    assert_redirected_to families_url
  end

  test "former should get create in own family" do
    assert_equal ["user", "former"], @former.clearance_levels
    create_success @former, @former.person.family
    assert_redirected_to family_person_path(@former.person.family.id, assigns(:person))
  end

  test "former should not get create in someone else's family" do
    assert_equal ["user", "former"], @former.clearance_levels
    create_failure @former, @user.person.family
    assert_redirected_to families_url
  end

  test "member should get new in own family" do
    assert_equal ["user", "member"], @member.clearance_levels
    new_test @member, @member.person.family
    assert_response :success
  end

  test "member should not get new in someone else's family" do
    assert_equal ["user", "member"], @member.clearance_levels
    new_test @member, @former.person.family
    assert_redirected_to families_url
  end

  test "member should get create in own family" do
    assert_equal ["user", "member"], @member.clearance_levels
    create_success @member, @member.person.family
    assert_redirected_to family_person_path(@member.person.family.id, assigns(:person))
  end

  test "member should not get create in someone else's family" do
    assert_equal ["user", "member"], @member.clearance_levels
    create_failure @member, @former.person.family
    assert_redirected_to families_url
  end

  test "web team should get new in any family" do
    assert_includes @web_team.clearance_levels, "web_team"
    new_test @web_team, @former.person.family
    assert_response :success
  end

  test "web team should get create in any family" do
    assert_includes @web_team.clearance_levels, "web_team"
    create_success @web_team, @former.person.family
    assert_redirected_to family_person_path(@former.person.family.id, assigns(:person))
  end
  
  #############################################################################
  # edit/update
  #############################################################################

  test "anonymous should not get edit" do
    edit_test nil, @person.family, @person
    assert_redirected_to root_url
  end

  test "anonymous should not get update" do
    update_test nil, @person.family, @person
    assert_redirected_to root_url
  end

  test "new user should get edit for own family" do
    assert_equal ["user", "new"], @user.clearance_levels
    edit_test @user, @user.person.family, @user.person
    assert_response :success
  end

  test "new user should not get edit for someone else's family" do
    assert_equal ["user", "new"], @user.clearance_levels
    edit_test @user, @former.person.family, @former.person
    assert_redirected_to families_url
  end

  test "new user should get update for own family" do
    assert_equal ["user", "new"], @user.clearance_levels
    update_test @user, @user.person.family, @user.person
    assert_redirected_to family_person_path(@user.person.family.id, @user.person.id)
  end

  test "new user should get update for someone else's family" do
    assert_equal ["user", "new"], @user.clearance_levels
    update_test @user, @member.person.family, @member.person
    assert_redirected_to families_url
  end

  test "former should get edit for own family" do
    assert_equal ["user", "former"], @former.clearance_levels
    edit_test @former, @former.person.family, @former.person
    assert_response :success
  end
  
  test "former should not get edit for someone else's family" do
    assert_equal ["user", "former"], @former.clearance_levels
    edit_test @former, @user.person.family, @user.person
    assert_redirected_to families_url
  end
  
  test "former should get update for own family" do
    assert_equal ["user", "former"], @former.clearance_levels
    update_test @former, @former.person.family, @former.person
    assert_redirected_to family_person_path(@former.person.family.id, @former.person.id)
  end

  test "former should not get update for someone else's family" do
    assert_equal ["user", "former"], @former.clearance_levels
    update_test @former, @member.person.family, @member.person
    assert_redirected_to families_url
  end

  test "member should get edit for own family" do
    assert_equal ["user", "member"], @member.clearance_levels
    edit_test @member, @member.person.family, @member.person
    assert_response :success
  end
  
  test "member should not get edit for someone else's family" do
    assert_equal ["user", "member"], @member.clearance_levels
    edit_test @member, @user.person.family, @user.person
    assert_redirected_to families_url
  end
  
  test "member should get update for own family" do
    assert_equal ["user", "member"], @member.clearance_levels
    update_test @member, @member.person.family, @member.person
    assert_redirected_to family_person_path(@member.person.family.id, @member.person.id)
  end
  
  test "member should not get update for someone else's family" do
    assert_equal ["user", "member"], @member.clearance_levels
    update_test @member, @user.person.family, @user.person
    assert_redirected_to families_url
  end
  
  test "web team should get edit for anyone's family" do
    assert_includes @web_team.clearance_levels, "web_team"
    edit_test @web_team, @user.person.family, @user.person
    assert_response :success
  end
  
  test "web team should get update for anyone's family" do
    assert_includes @web_team.clearance_levels, "web_team"
    update_test @web_team, @member.person.family, @member.person
    assert_redirected_to family_person_path(@member.person.family.id, @member.person.id)
  end

  #############################################################################
  # destroy
  #############################################################################

  test "anonymous should not get destroy" do
    destroy_failure nil, @person.family, @person
    assert_redirected_to root_url
  end

  test "new user should not get destroy" do
    assert_equal ["user", "new"], @user.clearance_levels
    destroy_failure @user, @user.person.family, @user.person
    assert_redirected_to root_url
  end

  test "former should not get destroy" do
    assert_equal ["user", "former"], @former.clearance_levels
    destroy_failure @former, @former.person.family, @former.person
    assert_redirected_to root_url
  end

  test "member should not get destroy" do
    assert_equal ["user", "member"], @member.clearance_levels
    destroy_failure @member, @member.person.family, @member.person
    assert_redirected_to root_url
  end

  test "web team should get destroy if not primary adult or user's person" do
    assert_includes @web_team.clearance_levels, "web_team"
    # create a new person to destroy so we're sure it's not a primary or associated with a user
    p = @member.person.dup
    p.first_name = "New"
    p.save
    destroy_success @web_team, p.family, p
    assert_redirected_to family_url(p.family.id)
  end
  
  test "web team should not get destroy if primary adult" do
    assert_includes @web_team.clearance_levels, "web_team"
    p = @member.person
    @member.person = nil
    p.family.primary_adult = @p
    destroy_failure @web_team, p.family, p
    assert_redirected_to families_url
  end
  
  test "web team should not get destroy if user's person" do
    assert_includes @web_team.clearance_levels, "web_team"
    p = @member.person
    destroy_failure @web_team, p.family, p
    assert_redirected_to families_url
  end

  #############################################################################
  # HELPERS
  #############################################################################

  # try to :new a new person as the given user in the given family
  def new_test user, family
    sign_in user unless !user
    get :new, family_id: family.id
  end

  # try to :create a new person as the given user in the given family, we expect success
  def create_success user, family
    create_test user, family, 1
  end
  
  # try to :create a new person as the given user in the given family, we expect failure
  def create_failure user, family
    create_test user, family, 0
  end

  # try to :create a new person as the given user in the given family, we expect the number of people
  # to change by diff amount
  def create_test user, family, diff
    sign_in user unless !user
    p = family.people.first.dup
    p.first_name = "New"
    assert_difference('Person.count', diff) do
      post :create, family_id: family.id, person: p.attributes
    end
  end

  # try to :edit the given person in the given family as the given person
  def edit_test user, family, person
    sign_in user unless !user
    get :edit, family_id: family.id, id: person.id
  end
  
  # try to :update the given person in the given family as the given person
  def update_test user, family, person
    sign_in user unless !user
    patch :update, family_id: family.id, id: person.id, person: person.attributes
  end
  
  # try to :destroy a person as the given user in the given family, we expect success
  def destroy_success user, family, person
    destroy_test user, family, person, -1
  end
  
  # try to :destroy a person as the given user in the given family, we expect success
  def destroy_failure user, family, person
    destroy_test user, family, person, 0
  end

  # try to :destroy a person as the given user in the given family, we expect the number of people
  # to change by diff amount
  def destroy_test user, family, person, diff
    sign_in user unless !user
    assert_difference('Person.count', diff) do
      delete :destroy, family_id: family.id, id: person.id
    end
  end

end
