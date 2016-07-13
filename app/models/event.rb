class Event < ActiveRecord::Base
  belongs_to :calendar

  def self.add_events(token, public_cal, member_cal, dates)
    # deal with planning dates
    add_event(token, member_cal, dates[:class_offering_open][:label],
              "#{dates[:class_offering_open][:date]} 00:00 -0400".to_datetime,
              "#{dates[:class_offering_close][:date]} 00:00 -0400".to_datetime)
    add_event(token, public_cal, dates[:schedule_posted][:label],
              "#{dates[:schedule_posted][:date]} 12:00 -0400".to_datetime,
              "#{dates[:schedule_posted][:date]} 12:00 -0400".to_datetime)
    add_event(token, member_cal, dates[:member_reg_open][:label],
              "#{dates[:member_reg_open][:date]} 00:00 -0400".to_datetime,
              "#{dates[:reg_close][:date]} 00:00 -0400".to_datetime)
    add_event(token, member_cal, dates[:former_reg_open][:label],
              "#{dates[:former_reg_open][:date]} 00:00 -0400".to_datetime,
              "#{dates[:reg_close][:date]} 00:00 -0400".to_datetime)
    add_event(token, public_cal, dates[:new_reg_open][:label],
              "#{dates[:new_reg_open][:date]} 00:00 -0400".to_datetime,
              "#{dates[:reg_close][:date]} 00:00 -0400".to_datetime)
    add_event(token, public_cal, dates[:fees_posted][:label],
              "#{dates[:fees_posted][:date]} 23:30 -0400".to_datetime,
              "#{dates[:fees_posted][:date]} 23:30 -0400".to_datetime)
    add_event(token, public_cal, dates[:fees_due][:label],
              "#{dates[:fees_due][:date]} 23:30 -0400".to_datetime,
              "#{dates[:fees_due][:date]} 23:30 -0400".to_datetime)
    
    # deal with classes
    weeks = dates[:weeks].values.map(&:symbolize_keys)
    weeks.each do |week|
      add_event(token, member_cal, week[:label],
                "#{week[:date]} 10:00 -0400".to_datetime,
                "#{week[:date]} 15:00 -0400".to_datetime)
    end
  end
  
  # add one event to the google calendar and our database
  def self.add_event(token, cal, label, start_dt, end_dt)
    id = GoogleAPI.add_event(token, cal.google_id, label, start_dt, end_dt)
    cal.events.create!(title: label, start_dt: start_dt, end_dt: start_dt,
                       google_id: id)
  end

end
