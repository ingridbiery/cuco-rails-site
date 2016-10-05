class Person < ActiveRecord::Base
  belongs_to :family
  belongs_to :pronoun
  has_one :user # this is ok for an optional relationship
  has_many :course_signups
  has_many :courses, through: :course_signups

  default_scope -> { order(first_name: :asc) }

  validates_each :first_name, :last_name do |record, attr, value|
    record.errors.add(attr, 'must start with upper case') if value =~ /\A[[:lower:]]/
  end

  validates :first_name, presence: true,
                         length: { maximum: 30 }
  validates :last_name, presence: true,
                        length: { maximum: 30 }

  # it would be nice to validate dob for datetime, but it is not simple so we'll skip it
  # we would like to require it for kids and skip it for adults, but that is not
  # high priority, so we're allowing it to be skipped for now.
  
  validates :pronoun_id, presence: true,
                         numericality: true

  validates :family_id, presence: true,
                        numericality: true

  def preferred_pronouns
    Pronoun.find(pronoun_id).preferred_pronouns
  end

  # get the full name for this person
  def name
    "#{first_name} #{last_name}"
  end
  
  # return the person's age today
  def age
    age_on(Time.now.utc.to_date)
  end
  
  # return the person's age on the given date. If they're an adult, they won't have a dob in the
  # system, so deal with nil
  def age_on(date)
    if dob == nil
      nil
    else
      date.year - dob.year - ((date.month > dob.month || (date.month == dob.month && date.day >= dob.day)) ? 0 : 1)
    end
  end
end
