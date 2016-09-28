class Event < ActiveRecord::Base
  belongs_to :dates
  belongs_to :event_type
  validates :name, presence: true
  validates :start_dt, presence: true
  validates :end_dt, presence: true
  validate :start_not_after_end

  # get a text description of this event
  def status_text
    # if the start and end days are different
    if start_dt.to_date != end_dt.to_date
      # if the event has already started
      if start_dt <= Time.now
        "#{name} ending #{end_dt.strftime("%-m/%-d/%Y at %l:%M%P")}"
      else # the event has different start and end days and hasn't started yet
        "#{name} from #{start_dt.strftime("%-m/%-d/%Y at %l:%M%P")} to #{end_dt.strftime("%-m/%-d/%Y at %l:%M%P")}"
      end
    else # the event has the same start and end day
      # is the start and end time the same
      if start_dt == end_dt
        "#{name} on #{start_dt.strftime("%-m/%-d/%Y at %l:%M%P")}"
      else # start and end day is the same, but time is different
        "#{name} on #{start_dt.strftime("%-m/%-d/%Y from %l:%M%P")} to #{end_dt.strftime("%l:%M%P")}"
      end
    end
  end
  
  private
    def start_not_after_end
      if start_dt > end_dt
        errors.add("Start Time", "(#{start_dt}) is after End time (#{end_dt})")
      end
    end
end
