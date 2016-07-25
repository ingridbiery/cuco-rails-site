class CucoSession < ActiveRecord::Base
  has_many :courses, dependent: :destroy
<<<<<<< 0f24c38bdbb227bb2b97b1e89ebe1b8aad74781b
  has_one :dates, dependent: :destroy
=======
  has_and_belongs_to_many :families
>>>>>>> Connect Families and CucoSessions for membership in a session
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
