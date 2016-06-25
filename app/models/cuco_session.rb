class CucoSession < ActiveRecord::Base
  has_many :calendars, dependent: :destroy

  # get the dates of all the Tuesdays between two dates
  def self.calculate_tuesdays start_date, stop_date
    day = Date.parse(start_date)
    stop = Date.parse(stop_date)
    tuesdays = []

    # find the first Tuesday (day number 2)
    while day.wday != 2 do day += 1 end
    while day < stop do
      tuesdays.append(day)
      day += 7
    end
    tuesdays
  end
end
