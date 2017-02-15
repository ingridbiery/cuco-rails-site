class FamilySchedulesController < ApplicationController
  let :web_team, :manage_all
  let :user, :show # we'll restrict it below to only seeing own schedule
  
  before_action :set_family_schedule
  before_action :must_be_own_schedule

  def show
  end

  private
    # get the membership from params before doing anything else
    def set_family_schedule
      membership = Membership.find(params[:id])
      @family_schedule = membership.schedule
    end

    # only let the user see their own schedule
    def must_be_own_schedule
      unless current_user&.person&.family == @family_schedule.family or
             current_user&.can? :manage_all, :family_schedules
        not_authorized! message: "That's not your schedule."
      end
    end
    
end
