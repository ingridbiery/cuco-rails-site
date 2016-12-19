class Dates < ActiveRecord::Base
  belongs_to :cuco_session
  has_many :events, -> { order(start_dt: :asc) }, dependent: :destroy
  accepts_nested_attributes_for :events, allow_destroy: true
  # can't make required types a validation because on update, this object
  # gets updated before its events, so we'll just call it as a method

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
      if (event_type.name.to_sym != :courses and
          event_type.name.to_sym != :other) then
        create_planning_event(event_type, all_tuesdays.first)
      end
    end

    # store the unknown number of courses
    all_tuesdays.each_with_index do |tuesday, num|
      create_course_event(tuesday, num)
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
  
  # is it before signups for anyone?
  def is_before_signups?
    return (is_before_event?(get_event(:member_reg)) and
            is_before_event?(get_event(:former_reg)) and
            is_before_event?(get_event(:new_reg)))
  end
  
  # figure out if membership signups are currently open for the given user type
  def membership_signups_open?(user)
    return false unless user
    case user.membership
    when :member
      is_during_event?(get_event(:member_reg))
    when :former
      is_during_event?(get_event(:former_reg))
    else
      is_during_event?(get_event(:new_reg))
    end
  end

  # figure out if membership signups are currently open for anyone
  # (happens to be the same as when course_signups are open for now)
  def membership_signups_open?
    course_signups_open?
  end

  # figure out if course signups are currently open
  def course_signups_open?
    return (is_during_event?(get_event(:member_reg)) or
            is_during_event?(get_event(:former_reg)) or
            is_during_event?(get_event(:new_reg)))
  end

  # figure out if course offerings are currently open
  def course_offerings_open?
    is_during_event?(get_event(:course_offering))
  end

  def has_required_events?
    valid = true

    # look for missing types that are required
    req_types = EventType.select {|event_type| (event_type.name.to_sym == :new_reg or
                                                event_type.name.to_sym == :former_reg or
                                                event_type.name.to_sym == :member_reg)}
    req_types.each do |event_type|
      if events.where(event_type_id: event_type.id).count == 0
        errors.add(event_type.name, "missing")
        valid = false
      end
    end

    # look for duplicates where they are not allowed
    nodup_types = EventType.where.not(name: :courses).where.not(name: :other)
    nodup_types.each do |event_type|
      if events.where(event_type_id: event_type.id).count > 1
        errors.add(event_type.name, "appears more than once")
        valid = false
      end
    end
    valid
  end

  private
    # has this event started?
    def is_before_event?(e)
      return false unless e
      return Time.now < e.start_dt
    end
  
    # is this event over?
    def is_after_event?(e)
      return false unless e
      return Time.now > e.end_dt
    end

    # is it during this event
    def is_during_event?(e)
      return false unless e
      return (!is_before_event?(e) and !is_after_event?(e))
    end

    # find an event in the events list given the event type
    def get_event(type_name)
      events.find_by(event_type: EventType.find_by_name(type_name))
    end

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
