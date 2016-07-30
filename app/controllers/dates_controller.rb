class DatesController < ApplicationController
  let :google_admin, :all
  before_action :set_dates
  before_action :set_cuco_session

  def show
  end

  def edit
  end
  
  # update each of the Events
  def update
    @dates.update_dates(current_user.token, params[:results])
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
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def dates_params
      params.require(:dates).permit(:results)
    end
end
