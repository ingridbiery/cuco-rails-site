class Family < ActiveRecord::Base
  has_many :people, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :cuco_sessions, through: :memberships
  has_many :kids, -> { where.not(dob: nil) }, class_name: 'Person', foreign_key: :family_id
  has_many :adults, -> { where(dob: nil) }, class_name: 'Person', foreign_key: :family_id
  default_scope -> { order(name: :asc) }
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { maximum: 50 }
  validates :street_address, presence: true
  validates :city, presence: true,
                   length: { maximum: 50 }
  validates :state, presence: true,
                    length: { minimum: 2, maximum: 2 }
  validates :zip, presence: true,
                  length: { minimum: 5, maximum: 5 },
                  numericality: true
  validates :ec_first_name, presence: true,
                            length: { maximum: 50 }
  validates :ec_last_name, presence: true,
                            length: { maximum: 50 }
  validates :ec_text, presence: true
  validates :ec_relationship, presence: true,
                              length: { maximum: 50 }


  # Based on https://codereview.stackexchange.com/questions/60171/refactoring-complex-phone-validations
  
  VALID_PHONE_FORMAT = /\A(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?\z/
  validates :ec_phone, format: { with: VALID_PHONE_FORMAT },
                       presence: true

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
  
   def clean_phone_number
     # As long as there is a valid phone number in the field, the following
     # will call the strip_bad_characters function below on the phone number
     # entered into that field.
     unless self.errors.any?
       self[:ec_phone] = strip_bad_characters(:ec_phone)
     end
   end
  
   def strip_bad_characters(attr)
     # This will strip any parentheses, dashes, and spaces from the phone number
     # leaving only a 10-digit integer. This 10-digit integer will then be added
     # to the database and accessible as @person.phone. See the person#show view
     # for an example of how to format this into a more human-readable format.
     input = read_attribute_before_type_cast(attr)
     input.gsub(/[^\d+!x]/, '') if input
   end

end
