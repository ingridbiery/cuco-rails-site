require 'test_helper'

class PronounTest < ActiveSupport::TestCase
  def setup
    @pronoun = pronouns(:he)
  end
  
  test "should be valid" do
    assert @pronoun.valid?
  end
  
  #############################################################################
  # preferred pronouns
  #############################################################################

  test "preferred_pronouns should be present" do
    @pronoun.preferred_pronouns = nil
    assert_not @pronoun.valid?
  end

  test "preferred_pronouns should be unique" do
    duplicate_pronoun = @pronoun.dup
    duplicate_pronoun.preferred_pronouns = @pronoun.preferred_pronouns.upcase
    @pronoun.save
    assert_not duplicate_pronoun.valid?
  end
end
