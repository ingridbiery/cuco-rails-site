class Membership < ActiveRecord::Base
  belongs_to :family
  belongs_to :cuco_session
  validates :family_id, :uniqueness => {:scope=>:cuco_session_id,
                                        :message => "already signed up for session"}
  scope :paid, -> { where(status: "Completed") }

  MEMBERSHIP_FEE = 23.85

  serialize :notification_params, Hash
  def paypal_url(return_path, paypal_hook_path)
    values = {
      business: ENV['PAYPAL_EMAIL'],
      cmd: "_xclick",
      upload: 1,
      return: "#{ENV['APP_HOST']}#{return_path}",
      invoice: id,
      amount: membership_fee.round(2),
      handling: electronic_payment_fee.round(2),
      item_name: "#{cuco_session.name} Membership",
      item_number: 1,
      quantity: '1',
      notify_url: "#{ENV['APP_HOST']}#{paypal_hook_path}"
    }
    "#{ENV['PAYPAL_HOST']}/cgi-bin/webscr?" + values.to_query
  end

  def membership_fee
    MEMBERSHIP_FEE
  end
  
  # fee is 3.5% plus 32 cents
  def electronic_payment_fee
    membership_fee*0.035 + 0.32
  end
end
