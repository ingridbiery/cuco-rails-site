require 'test_helper'

class VolunteerJobTypesControllerTest < ActionController::TestCase
  setup do
    @volunteer_job_type = volunteer_job_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:volunteer_job_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create volunteer_job_type" do
    assert_difference('VolunteerJobType.count') do
      post :create, volunteer_job_type: { description: @volunteer_job_type.description, name: @volunteer_job_type.name }
    end

    assert_redirected_to volunteer_job_type_path(assigns(:volunteer_job_type))
  end

  test "should show volunteer_job_type" do
    get :show, id: @volunteer_job_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @volunteer_job_type
    assert_response :success
  end

  test "should update volunteer_job_type" do
    patch :update, id: @volunteer_job_type, volunteer_job_type: { description: @volunteer_job_type.description, name: @volunteer_job_type.name }
    assert_redirected_to volunteer_job_type_path(assigns(:volunteer_job_type))
  end

  test "should destroy volunteer_job_type" do
    assert_difference('VolunteerJobType.count', -1) do
      delete :destroy, id: @volunteer_job_type
    end

    assert_redirected_to volunteer_job_types_path
  end
end
