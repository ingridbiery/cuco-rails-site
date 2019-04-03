# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  before_action :authenticate
  # saves the location before loading each page so we can return to the
  # right page. If we're on a devise page, we don't want to store that as the
  # place to return to (for example, we don't want to return to the sign_in page
  # after signing in), which is what the :unless prevents
  before_action :store_current_location, :unless => :devise_controller?
  
  # find information about current session and upcoming events to display in header
  before_action :get_session_info

  # set the site name
  before_action :set_site_name
  
  def get_session_info
    get_current_session_info
    get_next_session_info
  end

  # set the text to display for the current session in @current_session_info
  def get_current_session_info
    cuco_session = CucoSession.current
    if !cuco_session.nil? then
      @current_session_info = "Current Session: <a href='#{url_for(cuco_session)}'>".html_safe + "#{cuco_session.name}" + "</a>.".html_safe
      if !cuco_session.dates.nil? then
        next_event = cuco_session.dates.next_event(current_user)
        if next_event.nil? then
          @current_session_info += " No upcoming events"
        else
          @current_session_info += " #{next_event.status_text}"
        end
      end
    end
  end

  # set the text to display for the next session in @next_session_info
  # if signups are open, we will also set @membership_signup_info, and @next_cuco_session
  def get_next_session_info
    @next_cuco_session = CucoSession.upcoming
    if @next_cuco_session then
      @next_session_info = "Next Session: <a href='#{url_for(@next_cuco_session)}'>".html_safe + "#{@next_cuco_session.name}" + "</a>.".html_safe
      if @next_cuco_session.dates then
        next_event = @next_cuco_session.dates.next_event(current_user)
        if next_event then
          @next_session_info += " #{next_event.status_text}"
          if @next_cuco_session.membership_signups_open_for_anyone? then
            if @next_cuco_session.full?
              @membership_signup_info = "This session is full with #{@next_cuco_session.kids.count} out of #{CucoSession::MAX_KIDS} kids enrolled"
            else
              @membership_signup_info = "Membership signups are open with #{@next_cuco_session.kids.count} out of #{CucoSession::MAX_KIDS} kids currently enrolled."
            end
          end
        end
      else
        @next_session_info += " Dates not set yet. Please check back soon."
      end
    end
  end

  def set_site_name
    if Rails.env.production?
      if request.host == "cuco-beta.herokuapp.com"
        @site_name = "CUCO BETA"
      else
        @site_name = "CUCO"
      end
    else
      @site_name = "CUCO DEV"
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
    # always goes to the root path.
    def after_sign_out_path_for(resource)
      new_user_session_path
    end
  
  protected
    def authenticate
      # if this is our beta testing site, require a username/password
      if Rails.env.production? and request.host == "cuco-beta.herokuapp.com"
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
