class Dates < ActiveRecord::Base
  belongs_to :cuco_session
  has_many :events, dependent: :destroy
  
  # find an event in the events list given the event type
  def get_event(type_name)
    events.find_by(event_type: EventType.find_by_name(type_name))
  end

  # get all the courses
  def get_courses
    events.where(event_type: EventType.find_by_name(:courses))
  end
  
  # calculate the dates for this session, and create the Event objects and all the google
  # calendars and events
  def calculate_dates(token)
    self.public_calendar_gid = GoogleAPI.create_calendar(token, "Public #{cuco_session.name}")
    self.member_calendar_gid = GoogleAPI.create_calendar(token, "Member #{cuco_session.name}")
    self.save

    # find all Tuesdays between start and stop (by getting all dates between
    # start and end, then selecting all days where wday is 2 which is Tuesday's
    # number)
    all_tuesdays = (cuco_session.start_date..
                    cuco_session.end_date).select {|d| d.wday == 2}

    # store the basic dates (eventually, these constants might be configurable
    # somewhere online, but for now, we'll hardcode and we'll like it!)
    create_event(token, "Class Offerings", all_tuesdays.first - 33,
                 all_tuesdays.first - 28, :course_offering)
    create_event(token, "Schedule Posted", all_tuesdays.first - 27,
                all_tuesdays.first - 27, :schedule_posted)
    create_event(token, "Member Registration", all_tuesdays.first - 26,
                all_tuesdays.first - 19, :member_reg)
    create_event(token, "Former Member Registration", all_tuesdays.first - 25,
                all_tuesdays.first - 19, :former_reg)
    create_event(token, "New Member Registration", all_tuesdays.first - 24,
                all_tuesdays.first - 19, :new_reg)
    create_event(token, "Fees Posted", all_tuesdays.first - 18,
                all_tuesdays.first - 18, :fees_posted)
    create_event(token, "Fees Due", all_tuesdays.first - 14,
                all_tuesdays.first - 14, :fees_due)

    all_tuesdays.each_with_index do |tuesday, num|
      create_event(token, "Week #{num+1}", tuesday, tuesday, :courses)
    end
  end
  
  # the user has edited date information. Update all the events
  def update_dates(token, new_dates)
    update_event(token, get_event(:course_offering), new_dates[:course_offering])
    update_event(token, get_event(:schedule_posted), new_dates[:schedule_posted])
    update_event(token, get_event(:member_reg), new_dates[:member_reg])
    update_event(token, get_event(:former_reg), new_dates[:former_reg])
    update_event(token, get_event(:new_reg), new_dates[:new_reg])
    update_event(token, get_event(:fees_posted), new_dates[:fees_posted])
    update_event(token, get_event(:fees_due), new_dates[:fees_due])
    get_courses.each_with_index do |event, num|
      update_event(token, event, new_dates[:weeks]["#{num+1}"])
    end
  end
  
  # destroy the google calendars for this session. The dates object in the
  # database will be destroyed automatically
  def destroy_dates(token)
    GoogleAPI.destroy_calendar(token, public_calendar_gid)
    GoogleAPI.destroy_calendar(token, member_calendar_gid)
  end
  
  # find the next event (that is, the event whose date is soonest after today
  # filtered for the given user's membership level)
  def next_event(user)
    upcoming_events = get_upcoming_events
    return nil if upcoming_events.empty?
    event = upcoming_events.first
    # all registrations end on the same date, so pick the right one
    if (is_registration?(event)) then event = get_registration(user)
    elsif (user == nil or user.membership == :new and
           event.event_type.name.to_sym == :course_offering) then
      event = events.find_by(event_type: EventType.find_by_name(:schedule_posted))
    end
    event
  end
  
  # figure out if membership signups are currently open
  def membership_signup?(user)
    upcoming_events = get_upcoming_events
    # if the next event is a registration event
    if (!upcoming_events.empty? and is_registration?(upcoming_events.first))
      # get the right registration event for the current user type
      # if that event has already started, signups are open for this user
      if (get_registration(user).start_dt <= Time.now)
        return true
      end
    end
    # all other situations mean registration is not yet open
    return false
  end
    
  
  private
    # create an event and add it to the google calendar
    def create_event(token, name, start_date, end_date, type_name)
      start_dt = Time.zone.parse("#{start_date} #{get_start_time(type_name)}")
      end_dt = Time.zone.parse("#{end_date} #{get_end_time(type_name)}")
      gid = GoogleAPI.add_event(token, get_calendar_gid(type_name), name,
                                start_dt.utc.iso8601, end_dt.utc.iso8601)
      events.create!(name: name, start_dt: start_dt, end_dt: end_dt,
                     event_type: EventType.find_by_name(type_name), google_id: gid)
    end

    # update a single event object
    def update_event(token, event, new_info)
      event.name = new_info[:label]
      event.start_dt = Time.zone.parse("#{new_info[:start_date]} #{get_start_time(event.event_type.name)}")
      if new_info[:end_date] != nil
        event.end_dt = Time.zone.parse("#{new_info[:end_date]} #{get_end_time(event.event_type.name)}")
      else
        # there is no end_date in the form -- use the start_date again, but
        # use the end time (which is generally the same, but not for courses)
        event.end_dt = Time.zone.parse("#{new_info[:start_date]} #{get_end_time(event.event_type.name)}")
      end
      GoogleAPI.update_event(token, get_calendar_gid(event.event_type.name),
                             event.google_id, event.name,
                             event.start_dt.utc.iso8601, event.end_dt.utc.iso8601)
      event.save
    end

    # get the start time as a string for the given event type symbol
    def get_start_time(type_name)
      if type_name.to_sym == :schedule_posted
        "12:00"
      elsif type_name.to_sym == :courses
        "09:45"
      else
        "23:30"
      end
    end

    # get the end time as a string for the given event type symbol
    def get_end_time(type_name)
      if type_name.to_sym == :schedule_posted
        "12:00"
      elsif type_name.to_sym == :courses
        "15:15"
      else
        "23:30"
      end
    end
    
    # get the calendar id for the given event type
    def get_calendar_gid(type_name)
      if (type_name.to_sym == :course_offering or
          type_name.to_sym == :member_reg or
          type_name.to_sym == :former_reg)
        member_calendar_gid
      else
        public_calendar_gid
      end
    end
    
    # is this event one of the three registration events?
    def is_registration?(event)
      if (event.event_type.name.to_sym == :member_reg or
          event.event_type.name.to_sym == :former_reg or
          event.event_type.name.to_sym == :new_reg)
        true
      else
        false
      end
    end
    
    # get the right registration event for the given user type
    def get_registration(user)
      if (user == nil or user.membership == :new) then
        events.find_by(event_type: EventType.find_by_name(:new_reg))
      elsif (user.membership == :former)
        events.find_by(event_type: EventType.find_by_name(:former_reg))
      else
        events.find_by(event_type: EventType.find_by_name(:member_reg))
      end
    end
    
    # return just the events that havent finished yet
    def get_upcoming_events
      events.where('end_dt > ?', Time.now).order(end_dt: :asc)
    end
end
