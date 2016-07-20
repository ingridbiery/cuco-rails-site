class Room < ActiveRecord::Base
  belongs_to :courses
  validates :name, presence: true, uniqueness: { case_sensitive: false,
                                   message: "has already been added." }
end
