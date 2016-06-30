class Pronoun < ActiveRecord::Base
  has_many :people
  validates :pronouns, presence: true, uniqueness: { case_sensitive: false,
                                       message: "have already been added." }
end
