class CourseSignupsController < ApplicationController
  # :manage_all_users_signups is not a method, just a label to indicate who is allowed
  # to add/remove signups for everyone (instead of just their family)
  let :web_team, :manage_all_users_signups
  # current members are the only ones who can manage signups, again, only their own
  let :member, :all

  before_action :set_show_role
  before_action :set_cuco_session
  before_action :set_course, except: [:destroy]
  before_action :set_course_signup, except: [:new, :create]
  before_action :set_people, except: [:destroy]

  def new
    @course_signup = CourseSignup.new()
    # we want student to be selected by default
    @course_signup.course_role_id = CourseRole.find_by(name: params[:type]).id
  end
  
  def edit
  end

  def create
    @course_signup = CourseSignup.new(course_signup_params)
    # this next line validates the course_signup
    if @course_signup.save
      # and now, we check if there are any warnings
      if @course_signup.safe?
        notice += "#{@course_signup.name} added to #{@course.name}"
      else
        notice = "#{@course_signup.name} added to #{@course.name} with warnings."
        @course_signup.warnings.full_messages.each do |message|
          notice += " #{message}"
        end
      end
      redirect_to [@cuco_session, @course], notice: "#{notice}"
    else
      render :new_signup
    end
  end
  
  def update
    if @course_signup.update(course_signup_params)
      redirect_to [@cuco_session, @course], notice: "#{@course_signup.name} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @course_signup.destroy
    redirect_to [@cuco_session, @course_signup.course], notice: "#{@course_signup.name} was successfully removed from #{@course_signup.course.name}."
  end

  private
  
    # determine if we want to show the role in the form
    def set_show_role
      if params[:type] == "student"
        @show_role = false
      else
        @show_role = true
      end
    end

    # get the people that this user can add or remove from a course
    def set_people
      if current_user&.can? :manage_all_users_signups, :courses
        @people = @cuco_session.people
      else
        @people = current_user&.person&.family&.people
      end
    end

    def set_course_signup
      @course_signup = CourseSignup.find(params[:id])
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

    # get the cuco_session from params before doing anything else
    def set_cuco_session
      @cuco_session = CucoSession.find(params[:cuco_session_id])
    end

    def course_signup_params
      params.require(:course_signup).permit(:course_id, :person_id,
                                            :course_role_id)
    end
end
