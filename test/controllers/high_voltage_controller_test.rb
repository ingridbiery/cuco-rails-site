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
  
  test "should get FAQ" do
    get page_path("faq")
    assert_response :success
  end

  test "should get terms and conditions" do
    get page_path("terms-and-conditions")
    assert_response :success
  end

  test "should get waiver" do
    get page_path("waiver")
    assert_response :success
  end

  test "should get privacy" do
    get page_path("privacy")
    assert_response :success
  end
  
  test "should get refund" do
    get page_path("refund")
    assert_response :success
  end

  test "should get concern process" do
    get page_path("concern-process")
    assert_response :success
  end

end
