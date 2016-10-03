class VolunteerJobTypesController < ApplicationController
  let :web_team, :all
  let :member, [:show, :index]
  
  before_action :set_volunteer_job_type, only: [:show, :edit, :update, :destroy]

  def index
    @volunteer_job_types = VolunteerJobType.all.order(:name)
  end

  def show
  end

  def new
    @volunteer_job_type = VolunteerJobType.new
  end

  def edit
  end

  def create
    @volunteer_job_type = VolunteerJobType.new(volunteer_job_type_params)

    if @volunteer_job_type.save
      redirect_to @volunteer_job_type, notice: 'Volunteer job type was successfully created.'
    else
      render :new
    end
  end

  def update
    if @volunteer_job_type.update(volunteer_job_type_params)
      redirect_to @volunteer_job_type, notice: 'Volunteer job type was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @volunteer_job_type.destroy
    redirect_to volunteer_job_types_url, notice: 'Volunteer job type was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_volunteer_job_type
      @volunteer_job_type = VolunteerJobType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def volunteer_job_type_params
      params.require(:volunteer_job_type).permit(:name, :description)
    end
end
