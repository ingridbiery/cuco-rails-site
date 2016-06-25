class CucoSessionsController < ApplicationController
  let :admin, [:new, :add_event, :confirm_dates, :create]
  
  def new
  end

  # The user has entered the name of the session and the start and end dates
  # We need to calculate which dates are Tuesdays, then will automatically
  # render app/views/confirm_dates.html.erb which allows the user to confirm
  # those dates
  def confirm_dates
    @cuco_session_name = params[:cuco_session_name]
    @tuesdays = CucoSession.calculate_tuesdays(params[:start_date], params[:end_date])
  end
  
  # The user has confirmed dates for the session. Create the CucoSessions object
  # and all of its Calendars and Events
  # we're currently skipping error checking about if this session or any of its
  # stuff already exists
  def create
    params[:weeks] = params[:weeks].values.map(&:symbolize_keys)
    # create the session
    cs = CucoSession.create!(name: params[:cuco_session_name])
    # create public and private calendars (which will trigger creating the events)
    Calendar.create_calendars(current_user.token, cs, params)
    
    redirect_to calendar_path
  end

end
