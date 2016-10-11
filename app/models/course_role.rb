class CourseRole < ActiveRecord::Base
  has_many :course_signups
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true
  # note that presence: true doesn't work with booleans (because false is
  # not present)
  validates :is_worker, inclusion: [true, false]
  validates :display_weight, numericality: { only_integer: true,
                                             greater_than_or_equal_to: 0 }
end
