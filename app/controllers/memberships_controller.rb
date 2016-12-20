class MembershipsController < ApplicationController
  let :user, [:new, :create]
  let :user, :show_schedule # we'll restrict it below to only seeing own schedule
  let :web_team, :all
  let :all, :paypal_hook

  before_action :set_cuco_session, except: :paypal_hook
  before_action :set_membership, only: :show
  before_action :must_be_own_schedule, only: :show_schedule
  
  # the paypal hook gets called with no user and needs access that we wouldn't normally grant
  skip_before_action :authenticate, only: :paypal_hook
  protect_from_forgery except: :paypal_hook
  def paypal_hook
    params.permit! # Permit all Paypal input params
    status = params[:payment_status]
    if status == "Completed"
      @membership = Membership.find params[:invoice]
      @membership.update_attributes! notification_params: params, status: status, transaction_id: params[:txn_id], purchased_at: Time.now
    end
    render nothing: true
  end
  
  def new
    @membership = Membership.new
  end
  
  def create
    @membership = Membership.find_or_initialize_by(cuco_session: @cuco_session,
                                                   family: current_user.person.family)
    @membership.status = "Started"
    if @membership.save
      redirect_to @membership.paypal_url(cuco_session_membership_path(@cuco_session, @membership),
                                         paypal_hook_path)
    else
      render :new
    end
  end
  
  def show
  end
  
  def show_schedule
    @membership = Membership.find(params[:membership_id])
    
    student = CourseRole.find_by(name: :student)

    @fees = 0    
    @schedule = {}
    Period.find_each do |period|
      @schedule[period] = {}
      @membership.family.people.each do |person|
        @schedule[period][person.name] = @cuco_session.course_signups.where(person: person).joins(:course).where(courses: { period_id: period.id })
        @schedule[period][person.name].each do |signup|
          if signup.course_role == student then
            @fees += signup.course.fee
          end
        end
      end
    end
  end
  
  private

    # only let the user see their own schedule
    def must_be_own_schedule
      @membership = Membership.find(params[:membership_id])
      unless current_user&.person&.family == @membership.family or
             current_user&.can? :manage_all, :memberships
        not_authorized! message: "That's not your schedule."
      end
      
    end

    # get the cuco_session from params before doing anything else
    def set_cuco_session
      @cuco_session = CucoSession.find(params[:cuco_session_id])
    end

    # get the membership from params before doing anything else
    def set_membership
      @membership = Membership.find(params[:id])
    end
end