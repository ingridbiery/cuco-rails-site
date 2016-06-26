class Event < ActiveRecord::Base
  belongs_to :calendar
  
  def self.add_events(token, public_cal, member_cal, form_info)
    form_info[:weeks].each do |week|
      dt = week[:date].to_datetime
      GoogleAPI.add_event(token, public_cal.googleid, week[:label], dt, dt)
      public_cal.events.create!(title: week[:label], start: dt, end: dt)
    end
  end
end
