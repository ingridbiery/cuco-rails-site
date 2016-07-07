class Person < ActiveRecord::Base
  belongs_to :family
  has_one :pronoun
  default_scope -> { order(last_name: :asc) }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true
  validates :family_id, presence: true
  validates :pronoun_id, presence: true
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }

  def preferred_pronouns
    Pronoun.find(pronoun_id).preferred_pronouns
  end
end
