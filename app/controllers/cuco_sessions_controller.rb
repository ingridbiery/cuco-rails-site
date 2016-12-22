class CucoSessionsController < ApplicationController
  let :web_team, :all
  let :all, [:index, :show]
  let :paid, :show_open_jobs
  before_action :set_cuco_session, only: [:show, :edit, :update, :destroy]

  def index
    @cuco_sessions = CucoSession.all
  end
  
  def show
    # store rooms and periods so we only fetch them once and they're always in
    # the same order
    @rooms = Room.all
    @periods = Period.all
  end

  def new
    @cuco_session = CucoSession.new
  end

  def edit
  end

  def create
    @cuco_session = CucoSession.new(cuco_session_params)
    if @cuco_session.save
      d = Dates.create(cuco_session: @cuco_session)
      d.calculate_dates
      redirect_to @cuco_session, notice: "#{@cuco_session.name} was successfully created."
    else
      render :new
    end
  end

  def update
    # if the dates have changed, we need to update the @cuco_session.dates too
    if (@cuco_session.dates == nil or
        params[:start_date] != @cuco_session.start_date or
        params[:end_date] != @cuco_session.end_date) then
      update_dates = true
    end
    if @cuco_session.update(cuco_session_params)
      if update_dates
        @cuco_session.dates.destroy unless @cuco_session.dates == nil
        d = Dates.create(cuco_session: @cuco_session)
        d.calculate_dates
      end
      redirect_to @cuco_session, notice: "#{@cuco_session.name} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @cuco_session.destroy
    redirect_to cuco_sessions_path, notice: "#{@cuco_session.name} was successfully destroyed."
  end
  
  # show a list of jobs that haven't been taken yet
  def show_open_jobs
    @cuco_session = CucoSession.find(params[:cuco_session_id])
  end
  
  # show all class and volunteer signups for this session
  def show_all_signups
    @cuco_session = CucoSession.find(params[:cuco_session_id])
  end    
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cuco_session
      @cuco_session = CucoSession.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cuco_session_params
      params.require(:cuco_session).permit(:name, :start_date, :end_date)
    end

end
