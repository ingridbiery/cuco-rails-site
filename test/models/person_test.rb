require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  def setup
    @person = people(:isabella)
    @person2 = people(:emma)
  end
  
  test "should be valid" do
    assert @person.valid?
  end
  
  #############################################################################
  # first name
  #############################################################################

  test "first_name should be present" do
    @person.first_name = nil
    assert_not @person.valid?
  end

  test "first_name should not be too long" do
    @person.first_name = "a" * 31
    assert_not @person.valid?
  end

  test "first_name can not start with a capital letter" do
    @person.first_name = "aaaaaa"
    assert @person.valid?
  end

  test "name should not be the same as another name" do
    @person.first_name = @person2.first_name
    @person.last_name = @person2.last_name
    assert_not @person.valid?
  end

  #############################################################################
  # last name
  #############################################################################

  test "last_name should be present" do
    @person.last_name = nil
    assert_not @person.valid?
  end
  
  test "last_name should not be too long" do
    @person.last_name = "a" * 31
    assert_not @person.valid?
  end

  test "last_name can not start with a capital letter" do
    @person.last_name = "ssssss"
    assert @person.valid?
  end

  #############################################################################
  # pronoun id
  #############################################################################

  test "pronoun_id should exist" do
    @person.pronoun_id = nil
    assert_not @person.valid?
  end

  #############################################################################
  # family id
  # no validation on family id since we have a moment programmatically
  # when it is not set yet.
  #############################################################################

end
