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
  validates :ec_phone, presence: true,
                       numericality: true
  validates :ec_text, presence: true
  validates :ec_relationship, presence: true,
                              length: { maximum: 50 }


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
  
end
