require 'google/apis/calendar_v3'

class GoogleAPI
  # the access token for Google. We get this from oauth, but need to store the
  # token. This code is copy/paste so I'm not 100% sure what's going on.
  class AccessToken
    attr_reader :token
    def initialize(token)
      @token = token
    end
  
    def apply!(headers)
      headers['Authorization'] = "Bearer #{@token}"
    end
  end

  # check if we have a valid google authorization. Do this by making a meaningless
  # request of google to see if it returns with an error.
  def self.check_authorization?(current_user)
    return false if (current_user == nil || current_user.token == nil)
    access_token = AccessToken.new current_user.token
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = access_token
    calendar_id = 'primary'
    
    # catch the AuthorizationError if we're not authorized
    begin
      result = service.list_settings
      return true
    rescue Google::Apis::AuthorizationError
      return false
    end
  end
  
  # create a new google calendar
  def self.create_calendar(token, name)
    access_token = AccessToken.new token
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = access_token
    calendar = Google::Apis::CalendarV3::Calendar.new(summary: name)
    result = service.insert_calendar(calendar)
    return result.id
  end
end