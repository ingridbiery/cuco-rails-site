class Dates < ActiveRecord::Base
  belongs_to :cuco_session
  has_many :events
  
  def course_offering
    get_event(:course_offering)
  end
  def schedule_posted
    get_event(:schedule_posted)
  end
  def member_reg
    get_event(:member_reg)
  end
  def former_reg
    get_event(:former_reg)
  end
  def new_reg
    get_event(:new_reg)
  end
  def fees_posted
    get_event(:fees_posted)
  end
  def fees_due
    get_event(:fees_due)
  end
  def courses
    events.where(event_type: EventType.find_by(name: :courses))
  end
  
  def calculate_dates
    # find all Tuesdays between start and stop (by getting all dates between
    # start and end, then selecting all days where wday is 2 which is Tuesday's
    # number)
    all_tuesdays = (Date.parse(cuco_session.start_date)..
                    Date.parse(cuco_session.end_date)).select {|d| d.wday == 2}

    # store the basic dates (eventually, these constants might be configurable
    # somewhere online, but for now, we'll hardcode and we'll like it!)
    events.create!(name: "Class Offerings",
                                start_dt: Time.zone.parse("#{all_tuesdays.first - 33} 23:30"),
                                end_dt: Time.zone.parse("#{all_tuesdays.first - 28} 23:30"),
                                event_type: EventType.find_by(name: :course_offering),
                                members_only: true)
    events.create!(name: "Schedule Posted",
                                start_dt: Time.zone.parse("#{all_tuesdays.first - 27} 12:00"),
                                end_dt: Time.zone.parse("#{all_tuesdays.first - 27} 12:00"),
                                event_type: EventType.find_by(name: :schedule_posted),
                                members_only: false)
    events.create!(name: "Member Registration",
                                start_dt: Time.zone.parse("#{all_tuesdays.first - 26} 23:30"),
                                end_dt: Time.zone.parse("#{all_tuesdays.first - 21} 23:30"),
                                event_type: EventType.find_by(name: :member_reg),
                                members_only: true)
    events.create!(name: "Former Member Registration",
                                start_dt: Time.zone.parse("#{all_tuesdays.first - 25} 23:30"),
                                end_dt: Time.zone.parse("#{all_tuesdays.first - 20} 23:30"),
                                event_type: EventType.find_by(name: :former_reg),
                                members_only: true)
    events.create!(name: "New Member Registration",
                                start_dt: Time.zone.parse("#{all_tuesdays.first - 24} 23:30"),
                                end_dt: Time.zone.parse("#{all_tuesdays.first - 19} 23:30"),
                                event_type: EventType.find_by(name: :new_reg),
                                members_only: false)
    events.create!(name: "Fees Posted",
                                start_dt: Time.zone.parse("#{all_tuesdays.first - 18} 23:30"),
                                end_dt: Time.zone.parse("#{all_tuesdays.first - 18} 23:30"),
                                event_type: EventType.find_by(name: :fees_posted),
                                members_only: false)
    events.create!(name: "Fees Due",
                                start_dt: Time.zone.parse("#{all_tuesdays.first - 14} 23:30"),
                                end_dt: Time.zone.parse("#{all_tuesdays.first - 14} 23:30"),
                                event_type: EventType.find_by(name: :fees_due),
                                members_only: false)
                   
    all_tuesdays.each_with_index do |tuesday, num|
      events.create!(name: "Week #{num+1}",
                                  start_dt: Time.zone.parse("#{tuesday} 09:45"),
                                  end_dt: Time.zone.parse("#{tuesday} 15:15"),
                                  event_type: EventType.find_by(name: :courses),
                                  members_only: false)
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
    # return the Event object with given type name
    def get_event(name)
      events.find_by(event_type: EventType.find_by(name: name))
    end
    
    # update a single event object
    def update_event(event, new_info)
      event.name = new_info[:label]
      event.start_dt = new_info[:start_date].to_datetime
      event.end_dt = new_info[:end_date].to_datetime unless new_info[:end_date] == nil
      event.save
    end
end
