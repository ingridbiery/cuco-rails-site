class CucoSession < ActiveRecord::Base
  has_many :courses, dependent: :destroy
  has_one :dates, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :paid_memberships, -> { Membership.paid }, class_name: 'Membership', foreign_key: :cuco_session_id
  has_many :families, through: :paid_memberships
  has_many :kids, through: :families
  has_many :adults, through: :families
  has_many :people, through: :families
  has_many :course_signups, through: :courses
  
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
  # the start and end dates of the session)
  def self.current
    cuco_sessions = CucoSession.where('start_date <= ?', Time.now).where('? <= end_date', Time.now)
    return cuco_sessions.first.presence
  end

  # get the upcoming session, if there is one (the first session whose start date is
  # after today)
  def self.upcoming
    cuco_sessions = CucoSession.where('start_date >= ?', Time.now).order(start_date: :asc)
    cuco_sessions.first.presence
  end
  
  # get the latest session (may be the same as current, but if there is no current
  # session, this will get the last one that happened)
  # this is used to determine who is a member vs. a former member. See the user
  # model for details of that determination.
  def self.latest
    cuco_sessions = CucoSession.where('start_date < ?', Time.now).order(start_date: :desc)
    cuco_sessions.first.presence
  end
  
  # is this session currently full? That is, are there 100 or more kids signed up
  # we might want to make this limit configurable in the future, but for now,
  # it's hardcoded
  def full?
    return kids.count >= MAX_KIDS
  end
  
  # figure out if membership signups are currently open for the given user type
  def membership_signups_open?(user)
    # returns nil if dates nil, dates.membership_signups_open?(user) otherwise
    dates&.membership_signups_open?(user)
  end

  # are course signups currently open
  def course_signups_open?
    dates&.course_signups_open?
  end
  
  # are course offerings currently open.
  def course_offerings_open?
    dates&.course_offerings_open?
  end

  # is it currently before signups have started for anyone
  def is_before_signups?
    dates&.is_before_signups?
  end

  private
    # make sure the dates work
    def valid_dates
      if start_date.to_date >= end_date.to_date
        errors.add('Start date', 'is not before End date')
      end
    end
end
