class Event < ActiveRecord::Base
  belongs_to :dates
  belongs_to :event_type
  validates :name, presence: true
  validates :start_dt, presence: true
  validates :end_dt, presence: true

  # get a text description of this event
  def status_text
    if (start_dt != end_dt)
      if (start_dt <= Time.now)
        "#{name} ending #{end_dt.strftime("%-m/%-d/%Y at %l:%M%P")}"
      else
        "#{name} from #{start_dt.strftime("%-m/%-d/%Y at %l:%M%P")} to #{end_dt.strftime("%-m/%-d/%Y at %l:%M%P")}"
      end
    else
      "#{name} on #{start_dt.strftime("%-m/%-d/%Y at %l:%M%P")}"
    end
  end
end
