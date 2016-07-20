class Room < ActiveRecord::Base
  has_many :courses
  validates :name, presence: true, uniqueness: { case_sensitive: false,
                                   message: "has already been added." }
end
