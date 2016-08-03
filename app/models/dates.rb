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

    # store the basic dates
    EventType.all.each do |event_type|
      if (event_type.name.to_sym != :courses) then
        create_planning_event(token, event_type, all_tuesdays.first)
      end
    end

    # store the unknown number of courses
    all_tuesdays.each_with_index do |tuesday, num|
      create_course_event(token, tuesday, num)
    end
  end
  
  # the user has edited date information. Update all the events
  def update_dates(token, new_dates)
    events.each do |event|
      if (event.event_type.name.to_sym != :courses) then
        update_event(token, event, new_dates[event.event_type.name])
      end
    end
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
    if (event.event_type.registration) then event = get_registration(user)
    elsif (user.nil? or user.membership == :new and
           event.event_type.name.to_sym == :course_offering) then
      event = events.find_by(event_type: EventType.find_by_name(:schedule_posted))
    end
    event
  end
  
  # figure out if membership signups are currently open
  def membership_signup?(user)
    upcoming_events = get_upcoming_events
    # if the next event is a registration event
    if (!upcoming_events.empty? and upcoming_events.first.event_type.registration)
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
    # create a planning event
    def create_planning_event(token, event_type, first_class_date)
      start_dt = Time.zone.parse("#{first_class_date - event_type.start_date_offset} #{event_type.start_time.strftime("%H:%M")}")
      end_dt = Time.zone.parse("#{first_class_date - event_type.end_date_offset} #{event_type.end_time.strftime("%H:%M")}")
      create_event(token, event_type, start_dt, end_dt, event_type.display_name)
    end
    
    # create a course event
    def create_course_event(token, date, number)
      event_type = EventType.find_by_name(:courses)
      start_dt = Time.zone.parse("#{date} #{event_type.start_time.strftime("%H:%M")}")
      end_dt = Time.zone.parse("#{date} #{event_type.end_time.strftime("%H:%M")}")
      create_event(token, event_type, start_dt, end_dt, "#{event_type.display_name} #{number}")
    end
    
    # create the actual event and add it to the google calendar
    def create_event(token, event_type, start_dt, end_dt, name)
      gid = GoogleAPI.add_event(token, get_calendar_gid(event_type), event_type.display_name,
                                start_dt.utc.iso8601, end_dt.utc.iso8601)
      events.create!(name: name, start_dt: start_dt, end_dt: end_dt,
                     event_type: event_type, google_id: gid)
    end

    # update a single event object
    def update_event(token, event, new_info)
      event.name = new_info[:label]
      event.start_dt = Time.zone.parse("#{new_info[:start_date]} #{event.event_type.start_time.strftime("%H:%M")}")
      if !new_info[:end_date].nil?
        event.end_dt = Time.zone.parse("#{new_info[:end_date]} #{event.event_type.end_time.strftime("%H:%M")}")
      else
        # there is no end_date in the form -- use the start_date again, but
        # use the end time (which is generally the same, but not for courses)
        event.end_dt = Time.zone.parse("#{new_info[:start_date]} #{event.event_type.end_time.strftime("%H:%M")}")
      end
      GoogleAPI.update_event(token, get_calendar_gid(event.event_type),
                             event.google_id, event.name,
                             event.start_dt.utc.iso8601, event.end_dt.utc.iso8601)
      event.save
    end

    # get the calendar id for the given event type
    def get_calendar_gid(event_type)
      if (event_type.members_only)
        member_calendar_gid
      else
        public_calendar_gid
      end
    end
    
    # get the right registration event for the given user type
    def get_registration(user)
      if (user.nil? or user.membership == :new) then
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
