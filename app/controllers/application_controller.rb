# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  before_filter :authenticate
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  protected
    def authenticate
      if Rails.env.production?
        authenticate_or_request_with_http_basic do |username, password|
          username == "cucoDev" && password == "9cAN67Gw"
        end
      end
    end

end
