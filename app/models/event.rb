class Event < ActiveRecord::Base
  belongs_to :calendar
  
  def self.add_events(token, public_cal, member_cal, form_info)
    form_info[:weeks].each do |week|
      start_dt = week[:date] + " 10:00"
      start_dt = start_dt.to_datetime
      end_dt = week[:date] + " 15:00"
      end_dt = end_dt.to_datetime
      GoogleAPI.add_event(token, public_cal.googleid, week[:label], start_dt, end_dt)
      public_cal.events.create!(title: week[:label], start: start_dt, end: start_dt)
    end
  end
end
