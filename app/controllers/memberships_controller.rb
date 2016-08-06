class MembershipsController < ApplicationController
  # protect_from_forgery except: [:paypal_hook]
  # def paypal_hook
  #   params.permit! # Permit all Paypal input params
  #   status = params[:payment_status]
  #   if status == "Completed"
  #     # do something
  #   end
  #   render nothing: true
  # end
  
  # def create
  #   @membership = Membership.create(cuco_session: CucoSession.find(params[:cuco_session_id]),
  #                                   family: current_user.person.family)
  #   redirect_to @membership.paypal_url(user_path(current_user))
  # end
  
  # def show
  #   redirect_to root_path
  # end
end