class FamilySchedulesController < ApplicationController
  before_action :set_family_schedule

  def show
  end

  private
    # get the membership from params before doing anything else
    def set_family_schedule
      membership = Membership.find(params[:id])
      @family_schedule = membership.schedule
    end
end
