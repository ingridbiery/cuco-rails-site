require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = users(:js)
    @person = people(:jennifer)
    @family = families(:smith)
    @fall = cuco_sessions(:fall)
    @spring = cuco_sessions(:spring)
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  #############################################################################
  # email
  #############################################################################

  test "email should be present" do
    @user.email = "      "
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                        first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                          foo@bar_baz.com foo@bar+baz.com user@example..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  #############################################################################
  # notification list
  #############################################################################

  test "notification_list should be true/false" do
    @user.notification_list = nil
    assert_not @user.valid?
  end

  test "notification_list should allow false" do
    @user.notification_list = false
    assert @user.valid?
  end
  
  #############################################################################
  # membership type
  #############################################################################

  test "user with no person should be :new" do
    @user.person = nil
    assert_equal :new, @user.membership_status
  end

  test "user with no membership should be :new" do
    assert_equal :new, @user.membership_status
  end

  test "member of previous session should be :former after new session starts" do
    travel_to @fall.start_date.to_date + 1
    @user.person.family.cuco_sessions << @spring
    assert_equal :former, @user.membership_status
  end

  test "member of previous session should be :member before new session registration starts" do
    CucoSession.clear_caches
    travel_to @fall.dates.events.find_by(event_type: EventType.find_by_name(:member_reg)).start_dt - 1.day
    @user.person.family.cuco_sessions << @spring
    assert_equal :member, @user.membership_status
  end

  test "not member of previous session should be :former before new session starts" do
    travel_to @fall.end_date.to_date + 1
    @user.person.family.cuco_sessions << @spring
    assert_equal :former, @user.membership_status
  end

  test "member of current session should be :member" do
    travel_to @fall.start_date.to_date + 1
    @user.person.family.cuco_sessions << @fall
    assert_equal :member, @user.membership_status
  end
end
