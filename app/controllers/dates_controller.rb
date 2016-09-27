class DatesController < ApplicationController
  let :web_team, :all
  before_action :set_dates
  before_action :set_cuco_session

  def show
  end

  def edit
  end
  
  # update each of the Events
  def update
    params[:dates][:events_attributes].values.each do |event_params|
      event = Event.find(event_params[:id])
      event.name = event_params[:name]
      # this is the railsy way of listing 5 parameters to Time.zone.local,
      # of the form: event_params["start_dt(1i)"], replacing 1 with 1..5
      # this is how datetimes are returned from a datetime_select
      event.start_dt = Time.zone.local(*(1..5).map { |num| event_params["start_dt(#{num}i)"] })
      event.end_dt = Time.zone.local(*(1..5).map { |num| event_params["end_dt(#{num}i)"] })
      event.save
    end    
    render :show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dates
      @dates = Dates.find(params[:id])
    end
    def set_cuco_session
      @cuco_session = CucoSession.find(params[:cuco_session_id])
    end
    
end
