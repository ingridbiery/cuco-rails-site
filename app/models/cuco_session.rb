class CucoSession < ActiveRecord::Base
  has_many :courses, dependent: :destroy
  has_one :dates, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :paid_memberships, -> { Membership.paid }, class_name: 'Membership', foreign_key: :cuco_session_id
  has_many :not_paid_memberships, -> { Membership.not_paid }, class_name: 'Membership', foreign_key: :cuco_session_id
  has_many :families, through: :paid_memberships
  has_many :kids, through: :families
  has_many :adults, through: :families
  has_many :people, through: :families
  has_many :assigned_courses, -> { Course.assigned }, class_name: 'Course', foreign_key: :cuco_session_id
  has_many :course_signups, through: :assigned_courses # filters out signups for courses that are not happening
  
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
    if !@current then
      cuco_sessions = CucoSession.where('start_date <= ?', Time.now).where('? <= end_date', Time.now)
      @current = cuco_sessions.first.presence
    end
    @current
  end

  # get the upcoming session, if there is one (the first session whose start date is
  # after today)
  def self.upcoming
    if !@upcoming
      cuco_sessions = CucoSession.where('start_date >= ?', Time.now).order(start_date: :asc)
      @upcoming = cuco_sessions.first.presence
    end
  end
  
  # get the latest session (may be the same as current, but if there is no current
  # session, this will get the last one that happened)
  # this is used to determine who is a member vs. a former member. See the user
  # model for details of that determination.
  def self.latest
    if !@latest then
      cuco_sessions = CucoSession.where('start_date < ?', Time.now).order(start_date: :desc)
      @latest = cuco_sessions.first.presence
    end
    @latest
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

  # figure out if membership signups are currently open for anyone
  def membership_signups_open_for_anyone?
    # returns nil if dates nil, dates.membership_signups_open? otherwise
    dates&.membership_signups_open_for_anyone?
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

  # find all signups for people who are not members of this session
  def non_member_signups
    ppl = people.to_a
    course_signups.includes(:person).select do |signup|
      !ppl.include?(signup.person)
    end
  end

  # check if this session has any signup errors
  def check_signups
    # if there are any signups for people who are not members of the session
    unless non_member_signups.count == 0
      errors.add('Session', 'contains signups for people who are not members')
    end
  end

  # create the default courses for this session (expected to be called only once
  # when the session is newly created). Use a random member of the webteam as the
  # creator so regular members can't edit
  def create_default_courses
    creator = Role.find_by(name: :web_team).users.first
    # a list of jobs that we need two of
    main_jobs = [:auditorium_monitor, :game_room_monitor, :gym_monitor, :playground_monitor]
    # double the existing list and add whatever else is needed
    main_jobs += main_jobs + [:floater]

    ["Before", "First", "Second", "Lunch", "Third", "Fourth", "After"].each_with_index do |period_name, index|
      period = Period.find_by(name: period_name)

      # set up job list for the given period
      if index == 0 then # before co-op
        jobs = [:auditorium_monitor, :set_up_manager, :volunteer_manager]
        jobs += jobs + [:floater]
      elsif index == 6 then # after co-op
        jobs = [:auditorium_monitor, :clean_up_manager]
        jobs += jobs + [:floater]
        index -= 1
      elsif index == 3 # lunch
        jobs = [:gym_monitor, :playground_monitor]
        jobs += jobs + [:lunch_clean_up_manager, :lunch_time_keeper]
        index = 2.5
      else # regular class periods
        jobs = main_jobs
        if index == 1 then # first period
          jobs += [:volunteer_manager, :volunteer_manager]
        end
        if (index > 3) then index -= 1 end
        c = courses.create!(name: "Not at Co-op (#{period_name})", short_name: "Away (#{index.to_s})", description: 'If you are not going to be at CUCO regularly this period please sign up as a student so we know not to look for you.', min_age: 0, max_age: 99, age_firm: false, min_students: 1, max_students: 100, fee: 0, supplies: '', room_reqs: '', time_reqs: '', drop_ins: true, additional_info: '', period_id: period.id, created_by_id: creator.id)
        c.rooms << Room.find_by(name: "Outside")
      end

      c = courses.create!(name: "Volunteers & Free Play (#{period_name})", short_name: "Vols & Free (#{index.to_s})", description: 'If you do not want a class assignment this period (either as a student or a volunteer), sign up as a student of this class. You can move freely among any of the open free play areas (auditorium, computer lab, game room, gym, playground).Note that not each area is open each period.This is also a placeholder for certain volunteer jobs.', min_age: 0, max_age: 99, age_firm: false, min_students: 1, max_students: 100, fee: 0, supplies: '', room_reqs: '', time_reqs: '', drop_ins: true, additional_info: '', period_id: period.id, created_by_id: creator.id)
      ["Outside", "Gym", "Auditorium", "Lobby", "Game"].each do |room_name|
        c.rooms << Room.find_by(name: room_name)
      end

      jobs.each do |job|
        role = CourseRole.find_by(name: job)
        CourseSignup.create(course: c, person: nil, course_role: role)
      end

      # create after hours volunteer jobs for everyone on the board
      if index == 5 then
        after_hours = CourseRole.find_by(name: :after_hours_volunteer)
        bod = Role.find_by(name: :board_of_directors)
        bod.users.each do |user|
          CourseSignup.create(course: c, person: user.person, course_role: after_hours)
        end
      end
    end
  end

  private
    # make sure the dates work
    def valid_dates
      if start_date.to_date >= end_date.to_date
        errors.add('Start date', 'is not before End date')
      end
    end
end
