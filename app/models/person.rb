class Person < ActiveRecord::Base
  belongs_to :family
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true
  validates :family_id, presence: true
end
