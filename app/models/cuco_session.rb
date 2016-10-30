class CucoSession < ActiveRecord::Base
  has_many :courses, dependent: :destroy
  has_one :dates, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :families, through: :memberships
  has_many :kids, through: :families
  has_many :adults, through: :families
  has_many :people, through: :families
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
  # the start date of registration (:member_reg) and end date of the rec center)
  def self.current
    cuco_sessions = CucoSession.where('start_date <= ?', Time.now).where('? <= end_date', Time.now)
    if !cuco_sessions.empty?
      return cuco_sessions.first
    else # no active session, check if we're past the start of registration of next session
      next_session = CucoSession.next
      if next_session
        next_member_reg = next_session&.dates&.events&.find_by(event_type: EventType.find_by_name(:member_reg))
        if next_member_reg and next_member_reg.start_dt <= Time.now and Time.now <= next_session.end_date 
          return next_session
        end
      end
    end
    # there is no active session, and we're not past registration for next
    nil
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
    return kids.count >= MAX_KIDS
  end
  
  # figure out if membership signups are currently open for the given user type
  def membership_signups_open?(user)
    # returns nil if dates nil, dates.membership_signups_open?(user) otherwise
    dates&.membership_signups_open?(user)
  end

  # are course signups currently open. We currently allow course signups during
  # the same times as membership signups, and the user has to have joined the
  # current session
  def course_signups_open?(user)
    dates&.membership_signups_open?(user) and families.include? user&.person&.family
  end
  
  # are course offerings currently open.
  def course_offerings_open?
    dates&.course_offerings_open?
  end

  private
    # make sure the dates work
    def valid_dates
      if start_date.to_date >= end_date.to_date
        errors.add('Start date', 'is not before End date')
      end
    end
end
