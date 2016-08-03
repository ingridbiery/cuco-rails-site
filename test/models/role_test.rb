require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  def setup
    @role = roles(:user)
  end
  
  test "should be valid" do
    assert @role.valid?
  end
  
  test "name should be present" do
    @role.name = nil
    assert_not @role.valid?
  end

  test "name should be unique" do
    duplicate_role = @role.dup
    assert_not duplicate_role.valid?
  end
end
