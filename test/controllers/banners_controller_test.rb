require 'test_helper'

class BannersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @banner = banners(:one)
  end

  test "should show banner" do
    get banner_url(@banner)
    assert_response :success
  end

  test "should get edit" do
    get edit_banner_url(@banner)
    assert_response :success
  end

  test "should update banner" do
    patch banner_url(@banner), params: { banner: { banner: @banner.banner } }
    assert_redirected_to banner_url(@banner)
  end

end
