require 'test_helper'

class FamiliesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    CucoSession.clear_caches

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
    @member.roles << roles(:user)
    @spring = cuco_sessions(:spring)
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
    assert_equal ["user", "new"], @user.clearance_levels
    get :index
    assert_redirected_to root_path
  end

  test "web_team should get index" do
    travel_to @fall.start_date + 1.day
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
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
    assert_difference 'Family.count', 0 do
      post :create, params: { family: @family.attributes }
    end
    assert_redirected_to root_url
  end

  test "user without family should get new" do
    sign_in @user_without_fam
    assert_equal ["user", "new"], @user_without_fam.clearance_levels
    get :new
    assert_response :success
  end

  test "user without family should get create" do
    sign_in @user_without_fam
    assert_equal ["user", "new"], @user_without_fam.clearance_levels
    f = @family.dup
    f.name = "NEW NAME"
    family_attributes = f.attributes
    p = @kimberly.dup
    p.first_name = "NEW NAME"
    family_attributes[:person] = p.attributes
    family_attributes[:person][:user] = @user_without_fam.id
    assert_difference 'Family.count', 1 do
      post :create, params: { family: family_attributes }
    end
  end

  test "user with family should not get new" do
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    get :new
    assert_redirected_to families_url
  end

  test "user with family should not get create" do
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    f = @family.dup
    f.name = "NEW NAME"
    family_attributes = f.attributes
    p = @kimberly.dup
    p.first_name = "NEW NAME"
    family_attributes[:person] = p.attributes
    assert_difference 'Family.count', 0 do
      post :create, params: { family: @family.attributes }
    end
    assert_redirected_to families_url
  end

  #############################################################################
  # edit/update
  #############################################################################

  test "anonymous should not get edit" do
    get :edit, params: { id: @family.id }
    assert_redirected_to root_url
  end

  test "anonymous should not get update" do
    patch :update, params: { id: @family.id, family: @family }
    assert_redirected_to root_url
  end

  test "user with family should get edit for own family but not primary" do
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    get :edit, params: { id: @user.person.family.id }
    assert_select "select[id=family_primary_adult_id]", 0
    assert_response :success
  end

  test "user with family should get update for own family" do
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    family = @user.person.family
    patch :update, params: { id: family.id, family: family.attributes }
    assert_redirected_to family_path(assigns(:family))
  end

  test "user with family should not get edit for someone else's family" do
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    get :edit, params: { id: @family.id }
    assert_redirected_to families_url
  end
  
  test "user with family should not get update for someone else's family" do
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    patch :update, params: { id: @family.id, family: @family.attributes }
    assert_redirected_to families_url
  end
  
  test "user without family should not get edit" do
    sign_in @user_without_fam
    assert_equal ["user", "new"], @user_without_fam.clearance_levels
    get :edit, params: { id: @family.id }
    assert_redirected_to families_url
  end
  
  test "user without family should not get update" do
    sign_in @user_without_fam
    assert_equal ["user", "new"], @user_without_fam.clearance_levels
    patch :update, params: { id: @family.id, family: @family.attributes }
    assert_redirected_to families_url
  end

  test "web team should get edit for any family with primary adult" do
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
    family = @user.person.family
    family.primary_adult_id = @user.person.id
    family.save
    get :edit, params: { id: family.id }
    assert_select "select[id=family_primary_adult_id]", 1
    assert_response :success
  end

  test "web team should get update for any family" do
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
    family = @user.person.family
    patch :update, params: { id: family.id, family: family.attributes }
    assert_redirected_to family_path(assigns(:family))
  end

  #############################################################################
  # destroy
  #############################################################################

  test "anonymous should not get destroy" do
    assert_difference 'Family.count', 0 do
      delete :destroy, params: { id: @family.id }
    end
    assert_redirected_to root_url
  end

  test "user with family should not get destroy for own family" do
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    assert_difference 'Family.count', 0 do
      delete :destroy, params: { id: @user.person.family.id }
    end
    assert_redirected_to root_url
  end

  test "user with family should not get destroy for someone else's family" do
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    assert_difference 'Family.count', 0 do
      delete :destroy, params: { id: @family.id }
    end
    assert_redirected_to root_url
  end
  
  test "user without family should not get destroy" do
    sign_in @user_without_fam
    assert_equal ["user", "new"], @user.clearance_levels
    assert_difference 'Family.count', 0 do
      delete :destroy, params: { id: @family.id }
    end
    assert_redirected_to root_url
  end

  test "web team should get destroy" do
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
    assert_difference 'Family.count', -1 do
      delete :destroy, params: { id: @user.person.family.id }
    end
    assert_redirected_to families_url
  end

  #############################################################################
  # show emergency contacts
  #############################################################################

  test "anonymous should not get show emergency contacts" do
    get :show_emergency_contacts
    assert_redirected_to root_url
  end

  test "user should not get show emergency contacts" do
    travel_to @fall.end_date.to_date + 1
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    get :show_emergency_contacts
    assert_redirected_to root_url
  end

  test "former should not get show emergency contacts" do
    travel_to @fall.start_date.to_date + 1
    sign_in @user
    @user.person.family.cuco_sessions << @spring
    assert_equal ["user", "former"], @user.clearance_levels
    get :show_emergency_contacts
    assert_redirected_to root_url
  end

  test "member should not get show emergency contacts" do
    travel_to @fall.start_date.to_date + 1
    sign_in @member
    assert_equal ["user", "member"], @member.clearance_levels
    get :show_emergency_contacts
    assert_redirected_to root_url
  end

  test "web team should get show emergency contacts" do
    travel_to @fall.end_date.to_date + 1
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
    get :show_emergency_contacts
    assert_response :success
  end

  #############################################################################
  # show directory
  #############################################################################

  test "anonymous should not get show directory" do
    get :show_member_directory
    assert_redirected_to root_url
  end

  test "user should not get show directory" do
    travel_to @fall.end_date.to_date + 1
    sign_in @user
    assert_equal ["user", "new"], @user.clearance_levels
    get :show_member_directory
    assert_redirected_to root_url
  end

  test "former should not get show directory" do
    travel_to @fall.start_date.to_date + 1
    sign_in @user
    @user.person.family.cuco_sessions << @spring
    assert_equal ["user", "former"], @user.clearance_levels
    get :show_member_directory
    assert_redirected_to root_url
  end

  test "member should get show directory" do
    travel_to @fall.start_date.to_date + 1
    sign_in @member
    assert_equal ["user", "member"], @member.clearance_levels
    get :show_member_directory
    assert_response :success
  end

  test "web team should get show directory" do
    travel_to @fall.end_date.to_date + 1
    sign_in @web_team
    assert_includes @web_team.clearance_levels, "web_team"
    get :show_member_directory
    assert_response :success
  end
end
