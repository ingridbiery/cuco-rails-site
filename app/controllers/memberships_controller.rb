class MembershipsController < ApplicationController
  let :user, [:new, :create]
  let :user, :show_schedule # we'll restrict it below to only seeing own schedule
  let :treasurer, [:add, :complete_add, :edit, :update, :show]
  let :web_team, :all
  let :all, :paypal_hook

  before_action :set_cuco_session, except: :paypal_hook
  before_action :set_membership, only: [:show, :edit, :update]
  before_action :must_be_own_schedule, only: :show_schedule
  before_action :family_info_must_be_correct, only: [:new, :create]
  before_action :confirm_signups_open, only: [:new, :create]
  
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

  # add is like new, but for an admin to add a membership for someone else
  def add
    @membership = Membership.new
    
    # Show families not already in the session.
    @families = Family.select{|family| !@cuco_session.families.include? family}
  end

  def edit
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

  # this is like create for add. That is, it is what is called when the submit button is pressed
  def complete_add
    @membership = Membership.new(membership_params)

    if @membership.save
      redirect_to cuco_session_path(@cuco_session),
                  notice: "#{@membership.family.name} was successfully added to #{@cuco_session.name}."
    else
      # Show families not already in the session.
      @families = Family.select{|family| !@cuco_session.families.include? family}
      render :add
    end
  end

  def update
    if @membership.update(membership_params)
      redirect_to cuco_session_path(@cuco_session),
                  notice: "#{@membership.family.name} was successfully updated."
    else
      render :edit
    end
  end

  def show
  end

  def show_schedule
    @membership = Membership.find(params[:membership_id])
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
    
    # only let new memberships be created when signups are open
    def confirm_signups_open
      unless current_user&.can? :manage_all, :families 
        if !@cuco_session.membership_signups_open?(current_user) then
          not_authorized! message: "Membership signups are not currently open."
        end
        if current_user.membership == :paid then
          not_authorized! message: "You have already paid."
        end
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
    
    # if the current user's family information is not valid,
    # force them to edit before continuing
    def family_info_must_be_correct
      family = current_user.person.family
      unless family.valid? and family.safe?
        redirect_to edit_family_path(current_user.person.family)
      end
    end
    
    def membership_params
      params.require(:membership).permit(:cuco_session_id, :family_id, :status)
    end
end