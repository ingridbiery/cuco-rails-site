class CucoSession < ActiveRecord::Base
  has_many :courses, dependent: :destroy
  has_one :dates, dependent: :destroy
  has_and_belongs_to_many :families
  validates :name, presence: true,
                   length: { minimum: 5, maximum: 30 },
                   uniqueness: { message: "already exists." }
  # it would be nice to validate date format too, but that's not easy so we'll skip it
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :valid_dates
  
  # make sure the dates work
  def valid_dates
    if start_date.to_date >= end_date.to_date
      errors.add('Start date', 'is not before End date')
    end
  end
end
