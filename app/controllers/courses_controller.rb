class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  def index
    @courses = Course.all
  end

  def show
  end

  def new
    @course = Course.new
  end

  def edit
  end

  def create
    @course = Course.new(course_params)
    
    @course.save
    redirect_to @course, notice: "#{@course.title} was successfully created."
  end

  def update
    if @course.update(course_params)
      redirect_to @course, notice: "#{@course.title} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @course.destroy
    redirect_to courses_path, notice: "#{@course.title} was successfully destroyed."
  end

  private

    def set_course
      @course = Course.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:title, :short_title, :description, :min_age,
                                     :max_age, :age_firm, :min_num_students,
                                     :max_num_students, :course_fee, :supplies,
                                     :room_requirements, :time_requirements,
                                     :drop_ins, :additional_info)
    end

end
