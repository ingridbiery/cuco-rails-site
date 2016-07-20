require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  def setup
    @room = rooms("Test Room")
  end
  
  test "should be valid" do
    assert @room.valid?
  end
  
  test "name should be present" do
    @room.name = nil
    assert_not @room.valid?
  end

  test "name should be unique" do
    duplicate_name = @name.dup
    duplicate_room.name = @room.name.upcase
    @room.save
    assert_not duplicate_room.valid?
  end

end
