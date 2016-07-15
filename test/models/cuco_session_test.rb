require 'test_helper'

class CucoSessionTest < ActiveSupport::TestCase
  def setup
    @cuco_session = cuco_sessions(:fall)
  end
  
  test "should be valid" do
    assert @cuco_session.valid?
  end
  
  test "name should be present" do
    @cuco_session.name = "    "
    assert_not @cuco_session.valid?
  end

  test "name should not be too short" do
     @cuco_session.name = "a" * 4
     assert_not @cuco_session.valid?
   end

  test "name should not be too long" do
     @cuco_session.name = "a" * 31
     assert_not @cuco_session.valid?
  end

  test "name should be unique" do
    duplicate_cuco_session = @cuco_session.dup
    @cuco_session.save
    assert_not duplicate_cuco_session.valid?
  end
end
