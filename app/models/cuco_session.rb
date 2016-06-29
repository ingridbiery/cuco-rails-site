class CucoSession < ActiveRecord::Base
  has_many :calendars, dependent: :destroy

  # get the proposed dates of all the events for the session
  # this will include the Tuesdays between start_date and stop_date as
  # well as whatever planning dates we need.
  def self.calculate_dates(start_date, stop_date)
    date = Date.parse(start_date)
    stop = Date.parse(stop_date)

    # find the first Tuesday (day number 2)
    while date.wday != 2 do date += 1 end
    
    # store the basic dates (eventually, these constants might be configurable
    # somewhere online, but for now, we'll hardcode and we'll like it!)
    # I'm not sure I love using exact hash keys that I have to remember elsewhere
    # but I'm not sure what a better approach is, since these dates have specific
    # meanings
    events = { :fees_due => date-14,
               :fees_posted => date-18,
               :reg_close => date-19,
               :new_reg_open => date-24,
               :former_reg_open => date-25,
               :member_reg_open => date-26,
               :schedule_posted => date-27,
               :class_offering_close => date-28,
               :class_offering_open => date-33,
               :weeks => []}

    # find all class days
    # I'm not thrilled about storing a bunch of dates and then an array of dates,
    # but since we have a variable number of dates, I couldn't think of a better
    # way
    while date < stop do
      events[:weeks].append(date)
      date += 7
    end
    
    events
  end
end
