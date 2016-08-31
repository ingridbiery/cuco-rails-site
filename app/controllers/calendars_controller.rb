class CalendarsController < ApplicationController
  let [:web_team, :member], :members_only
  let :all, :show

  def show
    # if the user can view members_only calendar stuff, show all events
    if user_signed_in? and current_user.can? :members_only, CalendarsController then
      @events = Event.all
    else # show only events whose type is not members_only
      @events = Event.joins(:event_type).where(event_types: { members_only: false })
    end
  end
end
