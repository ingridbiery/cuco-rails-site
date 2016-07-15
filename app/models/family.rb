class Family < ActiveRecord::Base
  has_many :people, dependent: :destroy
  default_scope -> { order(name: :asc) }
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false },
                   length: { maximum: 50 }
  validates :street_address, presence: true
  validates :city, presence: true,
                   length: { maximum: 50 }
  validates :state, presence: true,
                    length: { minimum: 2, maximum: 2 }
  validates :zip, presence: true,
                  length: { minimum: 5, maximum: 5 },
                  numericality: true
         
  # get the person object for the primary adult of this family         
  def primary_adult
    Person.find_by_id(primary_adult_id)
  end
end
