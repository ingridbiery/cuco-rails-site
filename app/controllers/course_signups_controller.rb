class CourseSignupsController < ApplicationController
  let [:member, :web_team], [:new, :create, :destroy]
  let :web_team, :manage_all_users
  before_action :set_cuco_session, :set_course, :set_people

  def new
    @course_signup = CourseSignup.new()
  end
  
  def create
    @course_signup = CourseSignup.new(course_id: @course.id, person_id: params[:course_signup][:person_id])
    if @course_signup.save
      redirect_to [@cuco_session, @course], notice: "#{@course_signup.person.name} added to #{@course.name}"
    else
      render :new
    end
  end
  
  def destroy
    @course_signup = CourseSignup.find(params[:id])
    @course_signup.destroy
    redirect_to [@cuco_session, @course], notice: "#{@course_signup.person.name} was successfully removed from #{@course.name}."
  end

  private
    # get the people that this user can add to a course
    def set_people
      if current_user&.can? :manage_all_users, :course_signup
        @people = @cuco_session.people
      else
        @people = current_user&.person&.family.people
      end
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

    # get the cuco_session from params before doing anything else
    def set_cuco_session
      @cuco_session = CucoSession.find(params[:cuco_session_id])
    end

end
