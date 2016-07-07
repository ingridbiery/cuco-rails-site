class Person < ActiveRecord::Base
  belongs_to :family
  has_one :pronoun
  default_scope -> { order(last_name: :asc) }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true
  validates :family_id, presence: true
  validates :pronoun_id, presence: true

  VALID_PHONE_FORMAT = /\A(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?\z/
  
  after_validation :clean_phone_number

  def preferred_pronouns
    Pronoun.find(pronoun_id).preferred_pronouns
  end

  protected

    def clean_phone_number
      self[:phone] = strip_bad_characters(:phone)
    end

    def strip_bad_characters(attr)
      input = read_attribute_before_type_cast(attr)
      input.gsub(/[^\d+!x]/, '') if input
    end
end
