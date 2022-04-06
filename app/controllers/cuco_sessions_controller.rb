class CucoSessionsController < ApplicationController
  let :web_team, :all
  let [:volunteer_coordinator, :printable_manager],
          [:show_volunteers, :show_open_jobs, :show_all_signups_first_name,
           :show_all_signups_last_name, :show_away,
           :show_all_signups, :show_on_call, :show_adults]
  let :printable_manager, [:show_nametags, :show_printables, :show_ceramics_numbers]
  let :treasurer, :show_fees_summary
  let :all, [:index, :show]
  let :paid, :show_open_jobs
  let [:member, :paid], :show_rosters
  before_action :set_cuco_session, only: [:show, :edit, :update, :destroy]

  def index
    @cuco_sessions = CucoSession.all
  end

  def show
    # store rooms and periods so we only fetch them once and they're always in
    # the same order
    @rooms = Room.where("LENGTH(name) > 3")
    @periods = Period.where("LENGTH(name) > 3")
    @courses_by_period = @cuco_session.courses.group_by(&:period_id)
  end

  def new
    @cuco_session = CucoSession.new
  end

  def edit
  end

  def create
    @cuco_session = CucoSession.new(cuco_session_params)
    if @cuco_session.save
      d = Dates.create(cuco_session: @cuco_session)
      d.calculate_dates
      @cuco_session.create_default_courses
      redirect_to @cuco_session, notice: "#{@cuco_session.name} was successfully created."
    else
      render :new
    end
  end

  def update
    # if the dates have changed, we need to update the @cuco_session.dates too
    if (@cuco_session.dates == nil or
        params[:start_date] != @cuco_session.start_date or
        params[:end_date] != @cuco_session.end_date) then
      update_dates = true
    end
    if @cuco_session.update(cuco_session_params)
      if update_dates
        @cuco_session.dates.destroy unless @cuco_session.dates == nil
        d = Dates.create(cuco_session: @cuco_session)
        d.calculate_dates
      end
      redirect_to @cuco_session, notice: "#{@cuco_session.name} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @cuco_session.destroy
    redirect_to cuco_sessions_path, notice: "#{@cuco_session.name} was successfully destroyed."
  end

  # show a list of jobs that haven't been taken yet
  def show_open_jobs
    @cuco_session = CucoSession.find(params[:cuco_session_id])
    @signups = @cuco_session.course_signups.includes(course: :period).includes(:course_role).includes(:person).order('periods.start_time')
  end

  def show_volunteers
    @cuco_session = CucoSession.find(params[:cuco_session_id])
    @signups = @cuco_session.real_signups.includes([:course, :course_role, :person]).includes(course: :period).includes(person: :family)
                                         .order('periods.start_time', 'courses.name', 'course_roles.display_weight')
                                         .select{ |signup| (signup.course_role.is_worker or signup.course_role.is_helper or
                                                            signup.person == nil or signup.person&.adult?) }
  end

  def show_all_signups_first_name
    @cuco_session = CucoSession.find(params[:cuco_session_id])
    @signups = @cuco_session.real_signups.includes(course: :period).includes([:person, :course_role]).includes(person: :family)
                                         .order('periods.start_time', 'people.first_name', 'people.last_name')
  end

  def show_all_signups_last_name
    @cuco_session = CucoSession.find(params[:cuco_session_id])
    @signups = @cuco_session.real_signups.includes(course: :period).includes([:person, :course_role]).includes(person: :family)
                                         .order('periods.start_time', 'people.last_name', 'people.first_name')
  end

  def show_on_call
    @cuco_session = CucoSession.find(params[:cuco_session_id])
    @signups = @cuco_session.real_signups.includes(course: :period).includes([:person, :course_role]).includes(person: :family)
                                         .order('periods.start_time', 'people.last_name', 'people.first_name')
                                         .select{ |signup| signup.course_role.is_on_call? }
    @signups_by_period = []
    @signups.each { |signup|
      if !@signups_by_period[signup.course.period_id] then
        @signups_by_period[signup.course.period_id] = []
      end
      @signups_by_period[signup.course.period_id] << signup
    }
  end

  def show_adults
    @cuco_session = CucoSession.find(params[:cuco_session_id])
    @signups = @cuco_session.real_signups.includes(course: :period).includes([:person, :course_role]).includes(person: :family)
                                         .order('periods.start_time', 'people.last_name', 'people.first_name')
                                         .select{ |signup| signup.course_role.is_on_call? or (signup.person&.adult? and (!signup.course_role.is_worker? and !signup.course_role.is_helper?)) }
    @signups_by_period = []
    @signups.each { |signup|
      if !@signups_by_period[signup.course.period_id] then
        @signups_by_period[signup.course.period_id] = []
      end
      @signups_by_period[signup.course.period_id] << signup
    }
  end

  def show_away
    @cuco_session = CucoSession.find(params[:cuco_session_id])
    @signups = @cuco_session.course_signups.includes(course: :period).includes(:person)
                                           .order('periods.start_time', 'people.last_name', 'people.first_name')
                                           .select{|signup| signup.course.is_away? }
  end

  def show_nametags
    @cuco_session = CucoSession.find(params[:cuco_session_id])
    @not_returning_families = @cuco_session.not_returning_families
    @new_families = @cuco_session.new_families
    @returning_after_a_break_families = @cuco_session.returning_after_a_break_families
    @returning_families = @cuco_session.returning_families
  end

  # show all class and volunteer signups for this session
  def show_all_signups
    @cuco_session = CucoSession.find(params[:cuco_session_id])
    @memberships = @cuco_session.memberships.includes(:family).includes(family: :people).order('families.name')
  end

  def show_fees_summary
    @cuco_session = CucoSession.find(params[:cuco_session_id])
  end

  def show_rosters
    @cuco_session = CucoSession.find(params[:cuco_session_id])
    @courses = @cuco_session.assigned_courses.includes(course_signups: [:person, :course_role])
                                             .includes([:courses_rooms, :rooms, :course_signups])
                                             .includes(:period).order('periods.start_time')
                                             # I'm not sure how to optimize this more. The next line (put above the order line) makes it slower
                                             #    .includes([:helper_signups, :student_signups, :volunteer_signups, :waiting_list_signups, :person_in_room_signups])
  end

  def show_ceramics_numbers
    @people = Person.all.where.not(ceramics_number: nil)
    @max = @people.reorder(:ceramics_number).last&.ceramics_number
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cuco_session
      @cuco_session = CucoSession.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cuco_session_params
      params.require(:cuco_session).permit(:name, :start_date, :end_date)
    end

end
