class Period < ActiveRecord::Base
  has_many :courses
  default_scope -> { order(start_time: :asc) }
  validates :name, presence: true, uniqueness: { case_sensitive: false,
                                   message: "has already been added." }
end
