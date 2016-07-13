class Person < ActiveRecord::Base
  belongs_to :family
  has_one :pronoun
  default_scope -> { order(last_name: :asc) }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true
  validates :family_id, presence: true
  validates :pronoun_id, presence: true

  def preferred_pronouns
    Pronoun.find(pronoun_id).preferred_pronouns
  end

  # Based on https://codereview.stackexchange.com/questions/60171/refactoring-complex-phone-validations
  VALID_PHONE_FORMAT = /\A(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?\z/
  validates :phone, format: { with: VALID_PHONE_FORMAT },
                    allow_blank: true
  after_validation :clean_phone_number

  protected

    def clean_phone_number
      # As long as there is a valid phone number in the field, the following
      # will call the strip_bad_characters function below on the phone number
      # entered into that field.
      unless self.errors.any?
        self[:phone] = strip_bad_characters(:phone)
      end
    end

    def strip_bad_characters(attr)
      # This will strip any parentheses, dashes, and spaces from the phone number
      # leaving only a 10-digit integer. This 10-digit integer will then be added
      # to the database as accessible as @person.phone. See the person#show view
      # for an example of how to format this into a more human-readable format.
      input = read_attribute_before_type_cast(attr)
      input.gsub(/[^\d+!x]/, '') if input
    end
end
