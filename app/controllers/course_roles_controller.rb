class CourseRolesController < ApplicationController
  let :web_team, :all
  let :member, [:show, :index]
  
  before_action :set_course_role, only: [:show, :edit, :update, :destroy]

  def index
    @course_roles = CourseRole.all.order(:display_weight)
  end

  def show
  end

  def new
    @course_role = CourseRole.new
  end

  def edit
  end

  def create
    @course_role = CourseRole.new(course_role_params)

    if @course_role.save
      redirect_to @course_role, notice: 'Course role was successfully created.'
    else
      render :new
    end
  end

  def update
    if @course_role.update(course_role_params)
      redirect_to @course_role, notice: 'Course role was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @course_role.destroy
    redirect_to course_roles_url, notice: 'Course role was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_role
      @course_role = CourseRole.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_role_params
      params.require(:course_role).permit(:name, :is_worker, :display_weight, :description)
    end
end
