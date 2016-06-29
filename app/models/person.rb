class Person < ActiveRecord::Base
  belongs_to :family
  has_one :pronoun
  default_scope -> { order(last_name: :asc) }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true
  validates :family_id, presence: true
  validates :pronoun_id, presence: true
end
