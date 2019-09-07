class CourseRole < ActiveRecord::Base
  has_many :course_signups

  scope :student, -> { where(name: :student) }
  scope :waiting_list_member, -> { where(name: :waiting_list) }
  scope :on_call_volunteer, -> { where(name: :on_call_volunteer) }
  scope :person_in_room, -> { where(name: :person_in_room) }
  scope :teacher, -> { where(name: :teacher) }
  scope :volunteer, -> { where(is_worker: true) }
  scope :helper, -> { where(is_helper: true) }
  scope :non_working_role, -> { where(is_helper: false).where(is_worker: false) }

  default_scope -> { order(:display_weight) }

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true
  # note that presence: true doesn't work with booleans (because false is
  # not present)
  validates :is_worker, inclusion: [true, false]
  validates :is_helper, inclusion: [true, false]
  validates :display_weight, numericality: { only_integer: true,
                                             greater_than_or_equal_to: 0 }

  def is_on_call?
    name == "on_call_volunteer"
  end

  def is_student?
    name == "student"
  end

  # is this a role that is valid when there is no person assigned (for jobs that we want to create before we assign them)
  def can_be_unassigned?
    is_worker? or is_helper?
  end
end
