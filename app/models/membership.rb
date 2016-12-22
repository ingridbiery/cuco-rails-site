class Membership < ActiveRecord::Base
  belongs_to :family
  belongs_to :cuco_session
  scope :paid, -> { where(status: "Completed") }

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
      amount: membership_fee.round(2),
      handling: electronic_payment_fee(membership_fee).round(2),
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
  def self.electronic_payment_fee(base_fee)
    base_fee*0.035 + 0.32
  end
  
  def family_signups
    @family_signups || @family_signups = cuco_session.course_signups.where(person: family.people)
  end
  
  def family_fees
    fees = 0    
    @family_signups.each do |signup|
      if signup.is_student? then fees += signup.course.fee end
    end
    fees
  end
  
  def family_jobs
    jobs = 0
    @family_signups.each do |signup|
      if signup.is_volunteer_job? then jobs = jobs + 1 end
    end
    jobs
  end

  def family_unassigned
    unassigned = 0
    @family_signups.each do |signup|
      if signup.is_unassigned? then unassigned = unassigned + 1 end
    end
    unassigned
  end
end