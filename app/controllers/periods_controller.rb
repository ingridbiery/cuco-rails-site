class PeriodsController < ApplicationController
  let :web_team, [:index, :edit, :update]
  before_action :set_period, only: [:edit, :update]

  def index
    @periods = Period.all
  end

  def edit
  end

  def update
    if @period.update(period_params)
      redirect_to periods_path, notice: "#{@period.name} was successfully updated."
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_period
      @period = Period.find(params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def period_params
      params.require(:period).permit(:name, :start_time, :end_time, :required_signup)
    end
end
