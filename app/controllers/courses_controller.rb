class CoursesController < ApplicationController
  # :manage_all is not a method, just a label to indicate who is allowed
  # to manage all courses (instead of just their family or only during allowed times)
  let :web_team, :manage_all

  # :show_students is not a method, just a label to indicate who is allowed to see
  # the list of students in a course
  let [:web_team, :member, :paid], :show_students

  # who can create/edit/etc. courses; for other than web_team, people will only be
  # allowed to manage the courses they create
  let [:web_team, :member, :former], [:new, :create, :edit, :update, :destroy]

  # anyone, including anonymous users, can view courses
  let :all, [:index, :show]
  
  before_action :set_cuco_session
  before_action :set_course, except: [:new, :create, :index]
  before_action :set_people, only: [:show]

  # make sure the timing is right for new/create
  before_action :new_create_authorized, only: [:new, :create]

  # make sure the timing and user is right for edit/update/destroy
  before_action :edit_update_destroy_authorized, only: [:edit, :update, :destroy]

  def index
    @courses = @cuco_session.courses.all
  end

  def show
  end

  def new
    @course = Course.new
    @course.created_by_id = current_user.id
  end

  def edit
  end

  def create
    @course = @cuco_session.courses.build(course_params)

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
  
  private

    # make sure new and create are authorized
    # new/create is only available to typical users during course offerings
    # those who can :manage_all can do so at any time
    def new_create_authorized
      if !current_user&.can? :manage_all, :courses
        if !@cuco_session.course_offerings_open?
          not_authorized! path: root_url, message: "It is not time to create courses right now!"
        end
      end
    end
  
    # make sure edit and update are authorized
    # edit/update/destroy is only available to typical users during course offerings
    # regular users can only edit/update/destroy courses they created
    # those who can :manage_all can do so at any time
    def edit_update_destroy_authorized
      if !current_user&.can? :manage_all, :course_signups
        if !@cuco_session.course_offerings_open?
          not_authorized! path: root_url, message: "It is not time to edit courses right now!"
        elsif current_user != @course.created_by
          not_authorized! path: root_url, message: "You did not create this course!"
        end
      end
    end

    # get the people that this user can add or remove from a course
    def set_people
      if current_user&.can? :manage_all, :course_signups
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
                                     :period_id, :created_by_id)
    end

end
