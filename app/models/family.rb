class Family < ActiveRecord::Base
  include ActiveWarnings # allows us to validate for warning situations
                         # in addition to the built-in error validation

  has_many :people, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :paid_memberships, -> { Membership.paid }, class_name: 'Membership', foreign_key: :family_id
  has_many :cuco_sessions, through: :paid_memberships
  has_many :kids, -> { Person.kid }, class_name: 'Person', foreign_key: :family_id
  has_many :adults, -> { Person.adult }, class_name: 'Person', foreign_key: :family_id
  belongs_to :primary_adult, class_name: "Person"

  default_scope -> { order(name: :asc) }
  accepts_nested_attributes_for :people
  before_create :upcase_names
  
  SHORT_LEGAL_CHARS = /\A[a-zA-Z.' ]*\z/
  SHORT_LEGAL_CHARS_LIST = "letters, space, period, apostrophe."
  LONG_LEGAL_CHARS = /\A[a-zA-Z. \-\(\)\/']*\z/
  LONG_LEGAL_CHARS_LIST = "letters, space, period, apostrophe, dash, parentheses, slash."
  LEGAL_CHARS_MSG = "contains invalid characters. Valid characters: "
  
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { maximum: 50 },
                   format: { with: LONG_LEGAL_CHARS,
                             message: LEGAL_CHARS_MSG + LONG_LEGAL_CHARS_LIST}
  validates :street_address, presence: true
  validates :city, presence: true,
                   length: { maximum: 50 },
                   format: { with: SHORT_LEGAL_CHARS,
                             message: LEGAL_CHARS_MSG + SHORT_LEGAL_CHARS_LIST }
  validates :state, presence: true,
                    format: { with: /\A[A-Z][A-Z]\z/,
                             message: "should be two capital letters" }
  validates :zip, presence: true,
                  length: { minimum: 5, maximum: 5 },
                  numericality: true
  validates :ec_first_name, presence: true,
                            length: { maximum: 50 },
                            format: { with: SHORT_LEGAL_CHARS,
                                      message: LEGAL_CHARS_MSG + SHORT_LEGAL_CHARS_LIST }
  validates :ec_last_name, presence: true,
                           length: { maximum: 50 },
                           format: { with: LONG_LEGAL_CHARS,
                                     message: LEGAL_CHARS_MSG  + LONG_LEGAL_CHARS_LIST}
  validates :ec_relationship, presence: true,
                              length: { maximum: 50 },
                              format: { with: LONG_LEGAL_CHARS,
                                        message: LEGAL_CHARS_MSG + LONG_LEGAL_CHARS_LIST }

  # Based on https://codereview.stackexchange.com/questions/60171/refactoring-complex-phone-validations
  VALID_PHONE_FORMAT = /\A(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?\z/
  validates :ec_phone, :phone, format: { with: VALID_PHONE_FORMAT },
                               presence: true,
                               exclusion: { in: ["6145551212", "(614) 555-1212"],
                                            message: "%{value} is not a valid phone number."}
  # note that presence: true doesn't work with booleans (because false is
  # not present)
  validates :text, :ec_text, inclusion: [true, false]

  after_validation :clean_phone_number

  # get the person object for the primary adult of this family         
  def primary_adult
    Person.find_by_id(primary_adult_id)
  end
  
  # get the user associated with this family. nil if there isn't one
  def user
    people.each do |person|
      if person.user != nil
        return person.user
      end
    end
    return nil
  end
  
  protected
  
    # As long as there is a valid phone number in the field, the following
    # will call the strip_bad_characters function below on the phone number
    # entered into that field.
    def clean_phone_number
      unless self.errors.any?
        self[:ec_phone] = strip_bad_characters(:ec_phone)
      end
    end
  
    # This will strip any parentheses, dashes, and spaces from the phone number
    # leaving only a 10-digit integer. This 10-digit integer will then be added
    # to the database and accessible as @person.phone. See the person#show view
    # for an example of how to format this into a more human-readable format.
    def strip_bad_characters(attr)
      input = read_attribute_before_type_cast(attr)
      input.gsub(/[^\d+!x]/, '') if input
    end
   
    # make sure names start with an uppercase
    def upcase_names
      upcase name
      upcase ec_first_name
      upcase ec_last_name
    end

    # upcase the first letter of the given name      
    def upcase name
      name[0].upcase + name[1,name.length]
    end
    
    warnings do
      validate :people_correct

      # make sure all people in this family are validated when saving
      def people_correct
        people.each do |person|
          if !person.valid?
            person.errors.each do |error, message|
              errors.add(error, "#{message} for #{person.name}")
            end
          end
        end
      end
    end
end