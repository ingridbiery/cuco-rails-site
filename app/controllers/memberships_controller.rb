class MembershipsController < ApplicationController
  let :user, [:new, :create]
  let [:user, :member, :paid], :show_schedule
  let :web_team, :all
  let :all, :paypal_hook

  before_action :set_cuco_session, except: :paypal_hook
  before_action :set_membership, only: :show
  before_action :user_must_be_in_session, only: :show_schedule
  
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
    @periods = Period.all
    @people = Person.where(family_id: @membership.family_id)
    @signups = CourseSignup.all
    @roles = CourseRole.all
  end
  
  private

    # throw an error if current user's family is not in session
    # unless this user is exempt
    def user_must_be_in_session

      user_in_session = false
      session_membership = Membership.find(params[:membership_id])
      people_in_session =  Person.where(family_id: session_membership.family_id)

      if people_in_session.include? current_user&.person
        user_in_session = true
      end

      unless user_in_session == true or  current_user&.can? :manage_all, :families
        not_authorized! message: "Your family is not in #{@cuco_session.name}."
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