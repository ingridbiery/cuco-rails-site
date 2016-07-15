require 'test_helper'

class FamilyTest < ActiveSupport::TestCase
  def setup
    @family = families(:smith)
  end
  
  test "should be valid" do
    assert @family.valid?
  end
  
  test "name should be present" do
    @family.name = nil
    assert_not @family.valid?
  end

  test "street_address should be present" do
    @family.street_address = nil
    assert_not @family.valid?
  end

  test "city should be present" do
    @family.city = nil
    assert_not @family.valid?
  end

  test "state should be present" do
    @family.state = nil
    assert_not @family.valid?
  end

  test "zip should be present" do
    @family.zip = nil
    assert_not @family.valid?
  end

  test "name should not be too long" do
    @family.name = "a" * 51
    assert_not @family.valid?
  end

  test "name should be unique" do
    duplicate_family = @family.dup
    duplicate_family.name = @family.name.upcase
    @family.save
    assert_not duplicate_family.valid?
  end

  test "city should not be too long" do
    @family.city = "a" * 51
    assert_not @family.valid?
  end

  test "state should not be too short" do
    @family.state = "a" * 1
    assert_not @family.valid?
  end

  test "state should not be too long" do
    @family.state = "a" * 3
    assert_not @family.valid?
  end

  test "zip should be a number" do
    @family.zip = "a"
    assert_not @family.valid?
  end

  test "zip should not be too short" do
    @family.zip = "1" * 4
    assert_not @family.valid?
  end

  test "zip should not be too long" do
    @family.zip = "1" * 6
    assert_not @family.valid?
  end

end
