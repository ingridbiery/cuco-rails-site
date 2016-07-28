class Dates < ActiveRecord::Base
  belongs_to :cuco_session
  has_many :events
  
  def course_offering
    events.find_by(event_type: EventType.find_by_name(:course_offering))
  end
  def schedule_posted
    events.find_by(event_type: EventType.find_by_name(:schedule_posted))
  end
  def member_reg
    events.find_by(event_type: EventType.find_by_name(:member_reg))
  end
  def former_reg
    events.find_by(event_type: EventType.find_by_name(:former_reg))
  end
  def new_reg
    events.find_by(event_type: EventType.find_by_name(:new_reg))
  end
  def fees_posted
    events.find_by(event_type: EventType.find_by_name(:fees_posted))
  end
  def fees_due
    events.find_by(event_type: EventType.find_by_name(:fees_due))
  end
  def courses
    events.where(event_type: EventType.find_by_name(:courses))
  end
  
  def calculate_dates(token)
    self.public_calendar_gid = GoogleAPI.create_calendar(token, "Public #{cuco_session.name}")
    self.member_calendar_gid = GoogleAPI.create_calendar(token, "Member #{cuco_session.name}")
    self.save

    # find all Tuesdays between start and stop (by getting all dates between
    # start and end, then selecting all days where wday is 2 which is Tuesday's
    # number)
    all_tuesdays = (Date.parse(cuco_session.start_date)..
                    Date.parse(cuco_session.end_date)).select {|d| d.wday == 2}

    # store the basic dates (eventually, these constants might be configurable
    # somewhere online, but for now, we'll hardcode and we'll like it!)
    create_event(token, "Class Offerings", all_tuesdays.first - 33,
                 all_tuesdays.first - 28, :course_offering, member_calendar_gid)
    create_event(token, "Schedule Posted", all_tuesdays.first - 27,
                 all_tuesdays.first - 27, :schedule_posted, public_calendar_gid)
    create_event(token, "Member Registration", all_tuesdays.first - 26,
                 all_tuesdays.first - 21, :member_reg, member_calendar_gid)
    create_event(token, "Former Member Registration", all_tuesdays.first - 25,
                 all_tuesdays.first - 20, :former_reg, member_calendar_gid)
    create_event(token, "New Member Registration", all_tuesdays.first - 24,
                 all_tuesdays.first - 19, :new_reg, public_calendar_gid)
    create_event(token, "Fees Posted", all_tuesdays.first - 18,
                 all_tuesdays.first - 18, :fees_posted, public_calendar_gid)
    create_event(token, "Fees Due", all_tuesdays.first - 14,
                 all_tuesdays.first - 14, :fees_due, public_calendar_gid)

    all_tuesdays.each_with_index do |tuesday, num|
      create_event(token, "Week #{num+1}", tuesday, tuesday, :courses,
                   public_calendar_gid)
    end
  end
  
  # the user has edited date information. Update all the events
  def update_dates(new_dates)
    update_event(course_offering, new_dates[:course_offering])
    update_event(schedule_posted, new_dates[:schedule_posted])
    update_event(member_reg, new_dates[:member_reg])
    update_event(former_reg, new_dates[:former_reg])
    update_event(new_reg, new_dates[:new_reg])
    update_event(fees_posted, new_dates[:fees_posted])
    update_event(fees_due, new_dates[:fees_due])
    update_event(fees_due, new_dates[:fees_due])
    courses.each_with_index do |event, num|
      update_event(event, new_dates[:weeks]["#{num+1}"])
    end
  end

  private
    # create an event and add it to the google calendar
    def create_event(token, name, start_date, end_date, type_name, calendar_gid)
      start_dt = Time.zone.parse("#{start_date} #{get_start_time(type_name)}")
      end_dt = Time.zone.parse("#{end_date} #{get_end_time(type_name)}")
      id = GoogleAPI.add_event(token, calendar_gid, name, start_dt.utc.iso8601, end_dt.utc.iso8601)
      events.create!(name: name, start_dt: start_dt, end_dt: end_dt,
                     event_type: EventType.find_by_name(type_name), google_id: id)
    end

    # update a single event object
    def update_event(event, new_info)
      event.name = new_info[:label]
      event.start_dt = Time.zone.parse("#{new_info[:start_date]} #{get_start_time(event.event_type.name)}")
      if new_info[:end_date] != nil
        event.end_dt = Time.zone.parse("#{new_info[:end_date]} #{get_end_time(event.event_type.name)}")
      else
        # there is no end_date in the form -- use the start_date again, but
        # use the end time (which is generally the same, but not for courses)
        event.start_dt = Time.zone.parse("#{new_info[:start_date]} #{get_end_time(event.event_type.name)}")
      end
      event.save
    end

    # get the start time as a string for the given event type
    def get_start_time(type_name)
      if type_name == :schedule_posted
        "12:00"
      elsif type_name == :courses
        "09:45"
      end
      "23:30"
    end

    # get the end time as a string for the given event type
    def get_end_time(type_name)
      if type_name == :schedule_posted
        "12:00"
      elsif type_name == :courses
        "13:15"
      end
      "23:30"
    end
end
