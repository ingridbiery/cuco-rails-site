class CucoSession < ActiveRecord::Base
  has_many :courses, dependent: :destroy
  has_one :dates, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :families, through: :memberships
  validates :name, presence: true,
                   length: { minimum: 5, maximum: 30 },
                   uniqueness: { message: "already exists." }
  # it would be nice to validate date format too, but that's not easy so we'll skip it
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :valid_dates
  
  # maximum number of kids per sesson
  MAX_KIDS = 100
  
  # get the current session, if there is one (the session where today is between
  # the start and end dates of the rec center)
  def self.current
    cuco_sessions = CucoSession.where('start_date <= ?', Time.now).where('end_date >= ?', Time.now)
    # presence returns the object if it's there or nil if not
    cuco_sessions.first.presence
  end

  # get the next session, if there is one (the first session whose start date is
  # after today)
  def self.next
    cuco_sessions = CucoSession.where('start_date >= ?', Time.now).order(start_date: :asc)
    cuco_sessions.first.presence
  end
  
  # get the last session (may be the same as current, but if there is no current
  # session, this will get the last one that happened)
  # this is used to determine who is a member vs. a former member. Anyone who
  # is a member of this 'last' session will be classified as a :member, members
  # of older sessions will be classified as :former
  def self.last
    cuco_sessions = CucoSession.where('start_date < ?', Time.now).order(start_date: :desc)
    cuco_sessions.first.presence
  end
  
  # is this session currently full? That is, are there 100 or more kids signed up
  # we might want to make this limit configurable in the future, but for now,
  # it's hardcoded
  def full?
    return num_kids >= MAX_KIDS
  end
  
  # return the kids signed up for this session
  def kids
    result = []
    families.each do |family|
      result += family.kids
    end
    result
  end
  
  # return the adults signed up for this session
  def adults
    result = []
    families.each do |family|
      result += family.adults
    end
    result
  end

  private
    # make sure the dates work
    def valid_dates
      if start_date.to_date >= end_date.to_date
        errors.add('Start date', 'is not before End date')
      end
    end
end
