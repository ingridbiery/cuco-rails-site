# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  before_filter :authenticate
  # saves the location before loading each page so we can return to the
  # right page. If we're on a devise page, we don't want to store that as the
  # place to return to (for example, we don't want to return to the sign_in page
  # after signing in), which is what the :unless prevents
  before_filter :store_current_location, :unless => :devise_controller?
  
  # find information about current session and upcoming events to display in header
  before_filter :get_session_info
  def get_session_info
    @current_cuco_session = CucoSession.current
    @next_event_in_current = nil
    if !@current_cuco_session.nil? and !@current_cuco_session.dates.nil? then
      @next_event_in_current = @current_cuco_session.dates.next_event(current_user)
    end
    @next_cuco_session = CucoSession.next
    @next_event_in_next = nil
    if !@next_cuco_session.nil? and !@next_cuco_session.dates.nil? then
      @next_event_in_next = @next_cuco_session.dates.next_event(current_user)
      @membership_signup = @next_cuco_session.dates.membership_signup?(current_user)
    end
  end
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  private
    # override the devise helper to store the current location so we can
    # redirect to it after logging in or out. This override makes signing in
    # and signing up work automatically. Override after_sign_out_path
    # below for signing out.
    def store_current_location
      store_location_for(:user, request.url)
    end
  
    # override the devise method for where to go after signing out because theirs
    # always goes to the root path. Because devise uses a session variable and
    # the session is destroyed on log out, we need to use request.referrer
    # root_path is there as a backup
    def after_sign_out_path_for(resource)
      request.referrer || root_path
    end
  
  protected
    def authenticate
      if Rails.env.production?
        authenticate_or_request_with_http_basic do |username, password|
          username == "cucoDev" && password == "9cAN67Gw"
        end
      end
    end

  def configure_devise_permitted_parameters
    registration_params = [:email, :password, :password_confirmation, :notification_list]

    if params[:action] == 'update'
      devise_parameter_sanitizer.permit(:account_update) { 
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.permit(:sign_up) { 
        |u| u.permit(registration_params) 
      }
    end
  end


end
