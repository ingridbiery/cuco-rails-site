class Family < ActiveRecord::Base
  has_many :people, dependent: :destroy
  default_scope -> { order(name: :asc) }
  validates :family, presence: true,
                     uniqueness: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true,
                  length: { minimum: 5, maximum: 5 },
                  numericality: true
end
