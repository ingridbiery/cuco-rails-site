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
  
  # calculate the dates for this session, and create the Event objects
  def calculate_dates
    self.save

    # find all Tuesdays between start and stop (by getting all dates between
    # start and end, then selecting all days where wday is 2 which is Tuesday's
    # number)
    all_tuesdays = (cuco_session.start_date..
                    cuco_session.end_date).select {|d| d.wday == 2}

    # store the basic dates
    EventType.all.each do |event_type|
      if (event_type.name.to_sym != :courses) then
        create_planning_event(event_type, all_tuesdays.first)
      end
    end

    # store the unknown number of courses
    all_tuesdays.each_with_index do |tuesday, num|
      create_course_event(tuesday, num)
    end
  end
  
  # the user has edited date information. Update all the events
  def update_dates(new_dates)
    events.each do |event|
      if (event.event_type.name.to_sym != :courses) then
        update_event(event, new_dates[event.event_type.name])
      end
    end
    get_courses.each_with_index do |event, num|
      update_event(event, new_dates[:weeks]["#{num+1}"])
    end
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
  
  # figure out if membership signups are currently open for the given user type
  def membership_signups_open?(user)
    case user.membership
    when :member
      e = get_event(:member_reg)
    when :former
      e = get_event(:former_reg)
    else
      e = get_event(:new_reg)
    end
    if (e.start_dt <= Time.now and Time.now <= e.end_dt)
      return true
    else
      return false
    end
  end
    
  private
    # create a planning event
    def create_planning_event(event_type, first_class_date)
      start_dt = Time.zone.parse("#{first_class_date - event_type.start_date_offset} #{event_type.start_time.strftime("%H:%M")}")
      end_dt = Time.zone.parse("#{first_class_date - event_type.end_date_offset} #{event_type.end_time.strftime("%H:%M")}")
      create_event(event_type, start_dt, end_dt, event_type.display_name)
    end
    
    # create a course event
    def create_course_event(date, number)
      event_type = EventType.find_by_name(:courses)
      start_dt = Time.zone.parse("#{date} #{event_type.start_time.strftime("%H:%M")}")
      end_dt = Time.zone.parse("#{date} #{event_type.end_time.strftime("%H:%M")}")
      create_event(event_type, start_dt, end_dt, "#{event_type.display_name} #{number+1}")
    end
    
    # create the actual event
    def create_event(event_type, start_dt, end_dt, name)
      events.create!(name: name, start_dt: start_dt, end_dt: end_dt,
                     event_type: event_type)
    end

    # update a single event object
    def update_event(event, new_info)
      event.name = new_info[:label]
      event.start_dt = Time.zone.parse("#{new_info[:start_date]} #{event.event_type.start_time.strftime("%H:%M")}")
      if !new_info[:end_date].nil?
        event.end_dt = Time.zone.parse("#{new_info[:end_date]} #{event.event_type.end_time.strftime("%H:%M")}")
      else
        # there is no end_date in the form -- use the start_date again, but
        # use the end time (which is generally the same, but not for courses)
        event.end_dt = Time.zone.parse("#{new_info[:start_date]} #{event.event_type.end_time.strftime("%H:%M")}")
      end
      event.save
    end

    # get the right registration event for the given user type
    def get_registration(user)
      if (user.nil? or user.membership == :new) then
        get_event(:new_reg)
      elsif (user.membership == :former)
        get_event(:former_reg)
      else
        get_event(:member_reg)
      end
    end
    
    # return just the events that havent finished yet
    def get_upcoming_events
      events.where('end_dt > ?', Time.now).order(end_dt: :asc)
    end
end
