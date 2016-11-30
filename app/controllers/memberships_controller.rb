class MembershipsController < ApplicationController
  let :user, [:new, :create]
  let :web_team, :all
  let :all, :paypal_hook
  before_action :set_cuco_session, except: :paypal_hook
  before_action :set_membership, only: :show

  protect_from_forgery except: :paypal_hook
  def paypal_hook
    params.permit! # Permit all Paypal input params
    status = params[:payment_status]
    if status == "Completed"
      @membership = Membership.find params[:invoice]
      @membership.update_attributes notification_params: params, status: status, transaction_id: params[:txn_id], purchased_at: Time.now
    end
    render nothing: true
  end
  
  def new
    @membership = Membership.new
  end
  
  def create
    @membership = Membership.new(cuco_session: CucoSession.find(params[:cuco_session_id]),
                                 family: current_user.person.family)
    if (@membership.save)
      redirect_to @membership.paypal_url(cuco_session_membership_path(@cuco_session, @membership),
                                         paypal_hook_path)
    else
      render :new
    end
  end
  
  def show
  end
  
  private

    # get the cuco_session from params before doing anything else
    def set_cuco_session
      @cuco_session = CucoSession.find(params[:cuco_session_id])
    end

    # get the membership from params before doing anything else
    def set_membership
      @membership = Membership.find(params[:id])
    end
end