class FamilySchedule
  include ActiveModel::Model

  attr_accessor :family, :cuco_session

  validate :check_missing_and_duplicates

  # how many jobs is each family responsible for
  MIN_JOB_REQUIREMENT = 2
  # how many unassigned volunteer slots is each family responsible for
  MIN_UNASSIGNED_REQUIREMENT = 1

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

  def unassigned
    unassigned = 0
    signups.each do |signup|
      if signup.is_unassigned? then unassigned = unassigned + 1 end
    end
    unassigned
  end
  
  def check_missing_and_duplicates
    if jobs < MIN_JOB_REQUIREMENT
      errors.add("Family Schedule", "Family needs at least #{MIN_JOB_REQUIREMENT} job(s)")
    end
    if unassigned < MIN_UNASSIGNED_REQUIREMENT and
       jobs < MIN_JOB_REQUIREMENT + MIN_UNASSIGNED_REQUIREMENT then
      errors.add("Family Schedule", "Family needs at least #{MIN_UNASSIGNED_REQUIREMENT} unassigned volunteering assignment(s)")
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
