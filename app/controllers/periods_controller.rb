class PeriodsController < ApplicationController
  let :web_team, [:index, :edit, :update]
  before_action :set_period, only: [:edit, :update]
  before_action :authenticate_user!

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
end
