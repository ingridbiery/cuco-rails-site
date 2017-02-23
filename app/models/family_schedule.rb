class FamilySchedule < ActiveRecord::Base
  belongs_to :family
  belongs_to :cuco_session

  # how many jobs is each family responsible for
  MIN_JOB_REQUIREMENT = 2
  # how many unassigned volunteer slots is each family responsible for
  MIN_UNASSIGNED_REQUIREMENT = 1

  def set_signups
    @family_signups = cuco_session.course_signups.where(person: family.people)
  end
  
  # it would be nice to do some caching here, but let's just make sure it works first
  def signups
    set_signups
    @family_signups
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
  
  def reload_and_check_schedule
    set_signups
    if jobs < MIN_JOB_REQUIREMENT
      errors.add("Family Schedule", "Family needs at least #{MIN_JOB_REQUIREMENT} job(s)")
    end
    if unassigned < MIN_UNASSIGNED_REQUIREMENT and
       jobs < MIN_JOB_REQUIREMENT + MIN_UNASSIGNED_REQUIREMENT then
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