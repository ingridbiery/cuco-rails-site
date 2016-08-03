class EventType < ActiveRecord::Base
  has_many :events
  validates :name, presence: true
  validates :display_name, presence: true
  validates :start_date_offset, presence: true,
                                numericality: { only_integer: true }
  validates :end_date_offset, presence: true,
                              numericality: { only_integer: true }
  # start_time and end_time are datetimes in the database, and validating
  # dates is not simple so we're skipping it
  validates :start_time, presence: true
  validates :end_time, presence: true
  # note that presence: true doesn't work with booleans (because false is
  # not present)
  validates :members_only, inclusion: [true, false]
  validates :registration, inclusion: [true, false]
end
