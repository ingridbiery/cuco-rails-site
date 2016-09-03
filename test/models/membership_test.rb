require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  def setup
    @membership = memberships(:one)
  end

  test "should be valid" do
    assert @membership.valid?
  end

  #############################################################################
  # unique
  #############################################################################
  
  test "family/session pair should be unique" do
    new_membership = @membership.dup
    assert_not new_membership.valid?
  end

end
