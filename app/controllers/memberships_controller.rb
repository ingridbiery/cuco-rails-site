class MembershipsController < ApplicationController
  before_action :set_cuco_session
  before_action :set_membership, only: :show

  protect_from_forgery except: [:paypal_hook]
  def paypal_hook
    params.permit! # Permit all Paypal input params
    status = params[:payment_status]
    if status == "Completed"
      # do something
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
      redirect_to @membership.paypal_url(cuco_session_membership_path(@cuco_session, @membership))
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