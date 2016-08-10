require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  def setup
    @person = people(:isabella)
  end
  
  test "should be valid" do
    assert @person.valid?
  end
  
  test "first_name should be present" do
    @person.first_name = nil
    assert_not @person.valid?
  end

  test "last_name should be present" do
    @person.last_name = nil
    assert_not @person.valid?
  end
  
  test "family_id should be present" do
    @person.family_id = nil
    assert_not @person.valid?
  end

  test "first_name should not be too long" do
    @person.first_name = "a" * 31
    assert_not @person.valid?
  end

  test "last_name should not be too long" do
    @person.last_name = "a" * 31
    assert_not @person.valid?
  end

  test "family_id should be a number" do
    @person.family_id = "a"
    assert_not @person.valid?
  end

end
