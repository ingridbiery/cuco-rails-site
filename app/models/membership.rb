class Membership < ActiveRecord::Base
  belongs_to :family
  belongs_to :cuco_session
  scope :paid, -> { where(status: "Completed") }

  validates_uniqueness_of :family_id, :scope => [:cuco_session_id]
  validates :status, presence: true

  MEMBERSHIP_FEE = 23.85
  # how many jobs is each family responsible for
  MIN_JOB_REQUIREMENT = 2
  # how many unassigned volunteer slots is each family responsible for
  MIN_UNASSIGNED_REQUIREMENT = 1

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
  
  def set_family_signups
    @family_signups = cuco_session.course_signups.where(person: family.people)
  end
  
  # it would be nice to do some caching here, but let's just make sure it works first
  def family_signups
    set_family_signups
    @family_signups
  end
  
  def family_fees
    fees = 0    
    family_signups.each do |signup|
      if signup.is_student? then fees += signup.course.fee end
    end
    fees
  end
  
  def family_jobs
    jobs = 0
    family_signups.each do |signup|
      if signup.is_volunteer_job? then jobs = jobs + 1 end
    end
    jobs
  end

  def family_unassigned
    unassigned = 0
    family_signups.each do |signup|
      if signup.is_unassigned? then unassigned = unassigned + 1 end
    end
    unassigned
  end
  
  def reload_and_check_family_schedule
    set_family_signups
    if family_jobs < MIN_JOB_REQUIREMENT
      errors.add("Family Schedule", "Family needs at least #{MIN_JOB_REQUIREMENT} job(s)")
    end
    if family_unassigned < MIN_UNASSIGNED_REQUIREMENT and
       family_jobs < MIN_JOB_REQUIREMENT + MIN_UNASSIGNED_REQUIREMENT then
      errors.add("Family Schedule", "Family needs at least #{MIN_UNASSIGNED_REQUIREMENT} unassigned volunteering assignment(s)")
    end
    family.people.each do |person|
      Period.find_each do |period|
        count = @family_signups.where(person_id: person.id).joins(:course).where(courses: { period_id: period.id }).count
        if count == 0 and period.required_signup then
          errors.add("Family Schedule", "#{person.name} has no assignment for #{period.name}")
        elsif count > 1 then
          errors.add("Family Schedule", "WARNING: #{person.name} has multiple assignments for #{period.name}")
        end
      end
    end
  end
end