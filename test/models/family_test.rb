require 'test_helper'

class FamilyTest < ActiveSupport::TestCase
  def setup
    @family = families(:smith)
  end
  
  test "should be valid" do
    assert @family.valid?
  end

  #############################################################################
  # name
  #############################################################################

  test "name should be present" do
    @family.name = nil
    assert_not @family.valid?
  end

  test "name should not be too long" do
    @family.name = "a" * 51
    assert_not @family.valid?
  end

  test "name should be unique" do
    duplicate_family = @family.dup
    duplicate_family.name = @family.name.upcase
    assert_not duplicate_family.valid?
  end

  test "name can contain certain non letter characters" do
    @family.name = "Smith-Jones/The Third.Five ()"
    assert @family.valid?
  end

  test "name can not contain other non letter characters" do
    @family.name = "Smith [1]"
    assert_not @family.valid?
  end

  #############################################################################
  # street address
  #############################################################################

  test "street_address should be present" do
    @family.street_address = nil
    assert_not @family.valid?
  end

  #############################################################################
  # city
  #############################################################################

  test "city should be present" do
    @family.city = nil
    assert_not @family.valid?
  end

  test "city should not be too long" do
    @family.city = "a" * 51
    assert_not @family.valid?
  end

  test "city can contain certain non letter characters" do
    @family.city = "St. Louis"
    assert @family.valid?
    @family.city = "B'klyn"
    assert @family.valid?
  end

  test "city can not contain other non letter characters" do
    @family.city = "Smith-Jones/The Third.Five ()"
    assert_not @family.valid?
  end

  #############################################################################
  # state
  #############################################################################

  test "state should be present" do
    @family.state = nil
    assert_not @family.valid?
  end

  test "state should be two capital letters" do
    @family.state = "a" * 1
    assert_not @family.valid?
    @family.state = "a" * 3
    assert_not @family.valid?
    @family.state = "aa"
    assert_not @family.valid?
    @family.state = "12"
    assert_not @family.valid?
    @family.state = "AB"
    assert @family.valid?
  end

  #############################################################################
  # zip
  #############################################################################

  test "zip should be present" do
    @family.zip = nil
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

  #############################################################################
  # emergency contact first name
  #############################################################################

  test "ec_first_name should be present" do
    @family.ec_first_name = nil
    assert_not @family.valid?
  end

  test "ec_first_name should not be too long" do
    @family.ec_first_name = "1" * 51
    assert_not @family.valid?
  end

  test "ec_first_name can contain certain non letter characters" do
    @family.ec_first_name = "St. Louis"
    assert @family.valid?
    @family.ec_first_name = "B'klyn"
    assert @family.valid?
  end

  test "ec_first_name can not contain other non letter characters" do
    @family.ec_first_name = "Smith-Jones/The Third.Five ()"
    assert_not @family.valid?
  end

  #############################################################################
  # emergency contact last name
  #############################################################################

  test "ec_last_name should be present" do
    @family.ec_last_name = nil
    assert_not @family.valid?
  end

  test "ec_last_name should not be too long" do
    @family.ec_last_name = "1" * 51
    assert_not @family.valid?
  end

  test "ec_last_name can contain certain non letter characters" do
    @family.ec_last_name = "Smith-Jones/The Third.Five ()"
    assert @family.valid?
  end

  test "ec_last_name can not contain other non letter characters" do
    @family.ec_last_name = "Smith [1]"
    assert_not @family.valid?
  end

  #############################################################################
  # emergency contact phone
  #############################################################################

  test "ec_phone should be present" do
    @family.ec_phone = nil
    assert_not @family.valid?
  end

  test "ec_phone should be a valid phone number" do
    @family.ec_phone = "(614)555-1212"
    assert @family.valid?
    @family.ec_phone = "6145551212"
    assert @family.valid?
  end

  test "ec_phone should not be letters" do
    @family.ec_phone = "(614)555-slkj"
    assert_not @family.valid?
  end

  #############################################################################
  # emergency contact relationship
  #############################################################################

  test "ec_relationship should be present" do
    @family.ec_relationship = nil
    assert_not @family.valid?
  end

  test "ec_relationship should not be too long" do
    @family.ec_first_name = "1" * 51
    assert_not @family.valid?
  end

  test "ec_relationship can contain certain non letter characters" do
    @family.ec_relationship = "St. Louis"
    assert @family.valid?
    @family.ec_relationship = "B'klyn"
    assert @family.valid?
  end

  test "ec_relationship can not contain other non letter characters" do
    @family.ec_relationship = "Smith-Jones/The Third.Five ()"
    assert_not @family.valid?
  end

end
