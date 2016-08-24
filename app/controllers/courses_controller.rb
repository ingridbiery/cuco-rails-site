class CoursesController < ApplicationController
  before_action :set_cuco_session
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /cuco_sessions/:cuco_session_id/courses
  def index
    @courses = @cuco_session.courses.all
  end

  # GET /cuco_sessions/:cuco_session_id/courses/1
  def show
  end

  # GET /cuco_sessions/:cuco_session_id/courses/new
  def new
    @course = Course.new
  end

  # GET /cuco_sessions/:cuco_session_id/courses/1/edit
  def edit
  end

  # POST /cuco_sessions/:cuco_session_id/courses
  def create
    @course = Course.new(course_params)
    
    if @course.save
      redirect_to [@cuco_session, @course], notice: "#{@course.name} was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /cuco_sessions/:cuco_session_id/courses/1
  def update
    if @course.update(course_params)
      redirect_to [@cuco_session, @course], notice: "#{@course.name} was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /cuco_sessions/:cuco_session_id/courses/1
  def destroy
    @course.destroy
    redirect_to cuco_session_courses_path, notice: "#{@course.name} was successfully destroyed."
  end

  private

    def set_course
      @course = Course.find(params[:id])
    end

    # get the cuco_session from params before doing anything else
    def set_cuco_session
      @cuco_session = CucoSession.find(params[:cuco_session_id])
    end

    def course_params
      params.require(:course).permit(:name, :short_name, :description, :min_age,
                                     :max_age, :age_firm, :min_students,
                                     :max_students, :fee, :supplies,
                                     :room_reqs, :time_reqs,
                                     :drop_ins, :additional_info, :room_id,
                                     :period_id)
    end

end
