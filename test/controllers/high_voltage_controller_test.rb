require 'test_helper'

class HighVoltageControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get root_url
    assert_response :success
  end

  # home redirects to root
  test "should get home" do
    get page_path("home")
    assert_response 301
    assert_redirected_to root_url
  end

  test "should get day at cuco" do
    get page_path("dayatcuco")
    assert_response :success
  end

  test "should get expectations" do
    get page_path("expectations")
    assert_response :success
  end
end
