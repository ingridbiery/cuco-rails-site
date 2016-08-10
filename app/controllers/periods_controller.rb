class PeriodsController < ApplicationController
  let :web_team, [:edit, :update, :destroy, :create, :new]
  let :all, [:show, :index]
  before_action :set_period, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @periods = Period.all
  end

  def show
  end

  def new
    @period = Period.new
  end

  def edit
  end

  def create
    @period = Period.new(period_params)
    if @period.save
      redirect_to periods_path, notice: "#{@period.name} was successfully created."
    else
      render :new
    end
  end

  def update
    if @period.update(period_params)
      redirect_to periods_path, notice: "#{@period.name} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @period.destroy
    redirect_to periods_path, notice: "#{@period.name} successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_period
      @period = Period.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def period_params
      params.require(:period).permit(:name, :start_time, :end_time)
    end

end
