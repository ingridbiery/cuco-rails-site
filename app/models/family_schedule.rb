class FamilySchedule
  include ActiveModel::Model

  attr_accessor :family, :cuco_session

  validate :check_missing_and_duplicates

  # how many jobs is each family responsible for
  MIN_JOB_REQUIREMENT = 3
  # how many on call volunteer slots is each family responsible for
  # (we're no longer distinguishing between on call and regular jobs)
  MIN_ON_CALL_REQUIREMENT = 0

  def signups
    @family_signups ||= cuco_session.course_signups.includes(:course_role, :course).where(person: family.people)
  end

  def fees
    fees = 0
    signups.each do |signup|
      if signup.is_student? then fees += signup.course.fee end
    end
    fees
  end

  def jobs
    jobs = 0
    signups.each do |signup|
      if signup.is_volunteer_job? then jobs = jobs + 1 end
    end
    jobs
  end

  def on_call
    on_call = 0
    signups.each do |signup|
      if signup.is_on_call? then on_call = on_call + 1 end
    end
    on_call
  end

  def check_missing_and_duplicates
    if jobs < MIN_JOB_REQUIREMENT
      errors.add("Family Schedule", "Family needs at least #{MIN_JOB_REQUIREMENT} job(s)")
    end
    if on_call < MIN_ON_CALL_REQUIREMENT and
       jobs < MIN_JOB_REQUIREMENT + MIN_ON_CALL_REQUIREMENT then
      errors.add("Family Schedule", "Family needs at least #{MIN_ON_CALL_REQUIREMENT} on call volunteering assignment(s)")
    end
    grouped_by_person = signups.group_by(&:person_id)
    grouped_by_person.each do |person_id, signups_for_person|
      grouped_by_period = signups_for_person.group_by {|signup| signup.course.period_id}
      Period.find_each do |period|
        signups = grouped_by_period[period.id]
        count = signups ? signups.count : 0
        if count == 0 and period.required_signup then
          errors.add("Family Schedule", "#{Person.find(person_id).name} has no assignment for #{period.name}")
        elsif count > 1 then
          errors.add("Family Schedule", "WARNING: #{Person.find(person_id).name} has multiple assignments for #{period.name}")
        end
      end
    end
  end
end
