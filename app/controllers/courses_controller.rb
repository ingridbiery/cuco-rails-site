class CoursesController < ApplicationController
  # :manage_all_users_signups is not a method, just a label to indicate who is allowed
  # to add/remove signups for everyone (instead of just their family)
  let :web_team, :manage_all_users_signups
  # :show_students is not a method, just a label to indicate who is allowed to see
  # the list of students in a course
  let [:web_team, :member], :show_students
  # who can create/edit/etc. courses; for other than web_team, people will only be
  # allowed to manage the courses they create
  let [:web_team, :member, :former_member], [:new, :create, :edit, :update, :destroy]
  # current members are the only ones who can manage signups, again, only their own
  let :member, [:new_signup, :create_signup, :destroy_signup]
  # anyone, including anonymous users, can view courses
  let :all, [:index, :show]
  before_action :set_cuco_session
  before_action :set_course, except: [:new, :create, :index, :destroy_signup]
  before_action :set_people, only: [:show, :new_signup, :create_signup]

  def index
    @courses = @cuco_session.courses.all
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
    
    if @course.save
      redirect_to [@cuco_session, @course], notice: "#{@course.name} was successfully created."
    else
      render :new
    end
  end

  def update
    if @course.update(course_params)
      redirect_to [@cuco_session, @course], notice: "#{@course.name} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @course.destroy
    redirect_to cuco_session_courses_path, notice: "#{@course.name} was successfully destroyed."
  end
  
  def new_signup
    @show_role = true
    @show_role = false if params[:type] == "student"
    @course_signup = CourseSignup.new()
    # we want student to be selected by default
    @course_signup.course_role_id = CourseRole.find_by(name: params[:type]).id
  end
  
  def create_signup
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
      @show_role = true
      @show_role = false if CourseRole.find(params[:course_signup][:course_role_id]) == "student"
      render :new_signup
    end
  end
  
  def destroy_signup
    @course_signup = CourseSignup.find(params[:id])
    @course_signup.destroy
    redirect_to [@cuco_session, @course_signup.course], notice: "#{@course_signup.name} was successfully removed from #{@course_signup.course.name}."
  end

  private

    # get the people that this user can add or remove from a course
    def set_people
      if current_user&.can? :manage_all_users_signups, :courses
        @people = @cuco_session.people
      else
        @people = current_user&.person&.family&.people
      end
    end

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

    def course_signup_params
      params.require(:course_signup).permit(:course_id, :person_id,
                                            :course_role_id)
    end
end
