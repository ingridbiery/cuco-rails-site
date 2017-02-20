class CourseSignupsController < ApplicationController
  # this is a label indicating who is allowed
  # to manage signups for everyone (instead of just their family) and at any time
  let :web_team, :manage_all
  # this is a label indicating who can create signups during registration
  let [:web_team, :paid], :register
  # who is allowed to sign up ever (former members can create teaching jobs for classes
  # they offer, but will need to pay to edit/update)
  let [:web_team, :member, :former, :paid], [:new, :create]
  let [:web_team, :paid], [:edit, :update, :destroy]

  before_action :set_show_role # is the user allowed to change the course role?
  before_action :set_cuco_session
  before_action :set_course, except: [:destroy]
  before_action :set_course_signup, except: [:new, :create]
  before_action :set_people
  
  # make sure the timing is right for new/create
  before_action :new_create_authorized, only: [:new, :create]
  # make sure the timing is right for edit/update
  before_action :edit_update_authorized, only: [:edit, :update]
  # make sure the timing is right for destroy
  before_action :destroy_authorized, only: :destroy

  # type is whatever we want the default role to be
  def new
    @course_signup = CourseSignup.new()
    # we want the given type to be selected by default
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
        notice = "#{@course_signup.name} added to #{@course.name}"
      else
        notice = "#{@course_signup.name} added to #{@course.name} with warnings."
        @course_signup.warnings.full_messages.each do |message|
          notice += " #{message}"
        end
      end
      redirect_to [@cuco_session, @course], notice: "#{notice}"
    else
      render :new
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
  
    # make sure new and create are authorized
    # during registration, those who can :register can new/create anything
    # always, those who can :manage_all can new/create anything
    def new_create_authorized
      if !current_user&.can? :manage_all, :course_signups
        if @cuco_session.course_offerings_open?
          # people who can create new courses can also create volunteer jobs for those courses
          if current_user&.can? :new, :courses
            if is_student?
              not_authorized! path: root_url, message: "It is not time for student course offering!"
            end
          else # current user can't offer courses
            not_authorized! path: root_url, message: "You are not authorized to create signups during course offering!"
          end
        elsif @cuco_session.course_signups_open?
          if !current_user&.can? :register, :course_signups
            not_authorized! path: root_url, message: "You are not authorized to create signups during member signups!"
          end
        else # not course_offering or registration time
          not_authorized! path: root_url, message: "It is not time to create signups right now!"
        end
      end
    end
  
    # make sure edit and update are authorized
    # during registration, those who can :register can edit/update their own and blank
    # always, those who can :manage_all can edit/update anything
    def edit_update_authorized
      if !current_user&.can? :manage_all, :course_signups
        if @cuco_session.course_signups_open?
          if current_user&.can? :register, :course_signups
            if @course_signup.person and !@people.include? @course_signup.person
              not_authorized! path: root_url, message: "You are not authorized to edit that person's registration!"
            end
          else # current user can't ever register course signups
            not_authorized! path: root_url, message: "You are not authorized to edit signups!"
          end
        else # membership signups are not open
          not_authorized! path: root_url, message: "It is not time to edit signups right now!"
        end
      end
    end

    # make sure destroy is authorized
    # during registration, those who can :register can destroy their own student signups
    # but not their own teacher signups
    # always, those who can :manage_all can destroy anything
    def destroy_authorized
      if !current_user&.can? :manage_all, :course_signups
        if @cuco_session.course_signups_open?
          if current_user&.can? :register, :course_signups
            if !is_student?
              not_authorized! path: root_url, message: "You are not authorized to destroy teacher signups!"
            else # is student
              if !@people.include? @course_signup.person
                not_authorized! path: root_url, message: "You are not authorized to destroy this person's signups!"
              end
            end
          else # current user can't ever register course signups
            not_authorized! path: root_url, message: "You are not authorized to destroy signups!"
          end
        else # membership signups are not open
          not_authorized! path: root_url, message: "It is not time to destroy signups right now!"
        end
      end
    end

    # is this a student signup?
    def is_student?
      # for new, params[:type] will tell us which
      if params[:type] == "student"
        true
      elsif params[:type] == "teacher"
        false
      else
        # for create/update, we need to check what was selected
        if params[:course_signup]
          role_id = params[:course_signup][:course_role_id]
        else
          role_id = @course_signup.course_role_id
        end
        if CourseRole.find(role_id).name == "student"
          true
        else
          false
        end
      end
    end
  
    # determine if we want to show the role in the form
    def set_show_role
      @show_role = false
      if current_user&.can? :manage_all, :course_signup
        @show_role = true
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
