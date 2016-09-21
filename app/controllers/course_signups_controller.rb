class CourseSignupsController < ApplicationController
  let :member, [:new, :create]
  before_action :set_cuco_session
  before_action :set_course

  def new
    @course_signup = CourseSignup.new()
    @people = current_user.person.family.people
  end
  
  def create
    @course_signup = CourseSignup.new(course_id: @course.id, person_id: params[:course_signup][:person_id])
    if @course_signup.save
      redirect_to [@cuco_session, @course], notice: "#{@course_signup.person.name} added to #{@course.name}"
    else
      render :new_signup
    end
  end

  private

    def set_course
      @course = Course.find(params[:course_id])
    end

    # get the cuco_session from params before doing anything else
    def set_cuco_session
      @cuco_session = CucoSession.find(params[:cuco_session_id])
    end

end
