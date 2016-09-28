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
    if @dates.update_attributes(dates_params)
      flash[:notice] = "Successfully updated dates."
      redirect_to [@cuco_session, @dates]
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dates
      @dates = Dates.find(params[:id])
    end
    def set_cuco_session
      @cuco_session = CucoSession.find(params[:cuco_session_id])
    end
    
    def dates_params
      params.require(:dates).permit( { events_attributes: [:id, :name, :start_dt, :end_dt, :event_type_id, :_destroy] } )
    end
end
