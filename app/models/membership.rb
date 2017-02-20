class Membership < ActiveRecord::Base
  belongs_to :family
  belongs_to :cuco_session
  scope :paid, -> { where(status: "Completed") }
  scope :not_paid, -> { where.not(status: "Completed") }

  validates_uniqueness_of :family_id, :scope => [:cuco_session_id]

  MEMBERSHIP_FEE = 23.85

  serialize :notification_params, Hash
  def paypal_url(return_path, paypal_hook_path)
    values = {
      business: ENV['PAYPAL_EMAIL'],
      cmd: "_xclick",
      upload: 1,
      return: "#{ENV['APP_HOST']}#{return_path}",
      invoice: id,
      amount: Membership.membership_fee.round(2),
      handling: Membership.electronic_payment_fee(Membership.membership_fee).round(2),
      item_name: "#{cuco_session.name} Membership",
      item_number: 1,
      quantity: '1',
      notify_url: "#{ENV['APP_HOST']}#{paypal_hook_path}"
    }
    "#{ENV['PAYPAL_HOST']}/cgi-bin/webscr?" + values.to_query
  end

  def self.membership_fee
    MEMBERSHIP_FEE
  end
  
  # fee is 3.5% plus 32 cents
  def self.electronic_payment_fee(base_fee)
    base_fee*0.035 + 0.32
  end
  
  # get the FamilySchedule for this session/family combination
  # (it may or may not already exist)
  def schedule
    FamilySchedule.find_or_initialize_by(family_id: family.id, cuco_session_id: cuco_session.id)
  end
  
end