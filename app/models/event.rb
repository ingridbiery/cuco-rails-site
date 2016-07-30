class Event < ActiveRecord::Base
  belongs_to :dates
  belongs_to :event_type
  validates :name, presence: true
  validates :start_dt, presence: true
  validates :end_dt, presence: true

  # add one event to the google calendar and our database
  def self.add_event(token, cal, label, start_dt, end_dt)
    id = GoogleAPI.add_event(token, cal.google_id, label, start_dt, end_dt)
    cal.events.create!(title: label, start_dt: start_dt, end_dt: start_dt,
                       google_id: id)
  end
end
