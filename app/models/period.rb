class Period < ActiveRecord::Base
  has_many :courses
  default_scope -> { order(start_time: :asc) }
  validates :name, presence: true, uniqueness: { case_sensitive: false,
                                   message: "has already been added." }
  validates :start_time, presence: true, uniqueness: true
  validates :end_time, presence: true, uniqueness: true
  
  # a standard way of displaying the timing of the period
  def duration_text
    start_time.strftime("%l:%M%P") + " - " + end_time.strftime("%l:%M%P")
  end
end
