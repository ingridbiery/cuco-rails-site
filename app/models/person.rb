class Person < ActiveRecord::Base
  belongs_to :family
  has_one :pronoun
  has_one :user # this is ok for an optional relationship

  default_scope -> { order(last_name: :asc) }
  validates :first_name, presence: true,
                         length: { maximum: 30 }
  validates :last_name, presence: true,
                        length: { maximum: 30 }
  # it would be nice to validate dob for datetime, but it is not simple so we'll skip it
  # we would like to require it for kids and skip it for adults, but that is not
  # high priority, so we're allowing it to be skipped for now.
  validates :family_id, presence: true,
                        numericality: true
  # we want to require pronouns unless we're auto-creating a user or an admin is
  # creating it for someone. This doesn't quite do that, but again, it's not a
  # priority and this is close enough.
  validates :pronoun_id, presence: true,
                         numericality: true,
                         on: :update

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    allow_blank: true

  # Based on https://codereview.stackexchange.com/questions/60171/refactoring-complex-phone-validations
  VALID_PHONE_FORMAT = /\A(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?\z/
  validates :phone, format: { with: VALID_PHONE_FORMAT },
                    allow_blank: true
  after_validation :clean_phone_number

  def preferred_pronouns
    Pronoun.find(pronoun_id).preferred_pronouns
  end

  # get the full name for this person
  def name
    "#{first_name} #{last_name}"
  end

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
