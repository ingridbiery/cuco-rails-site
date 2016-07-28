require 'google/apis/calendar_v3'

class GoogleAPI
  # the colors that google allows calendars to be
  COLORS = ['%23B1365F', '%235C1158', '%23711616', '%23691426', '%23BE6D00',
            '%23B1440E', '%23853104', '%238C500B', '%23754916', '%2388880E',
            '%23AB8B00', '%23856508', '%2328754E', '%231B887A', '%2328754E',
            '%230D7813', '%23528800', '%23125A12', '%232F6309', '%232F6213',
            '%230F4B38', '%235F6B02', '%234A716C', '%236E6E41', '%2329527A',
            '%232952A3', '%234E5D6C', '%235A6986', '%23182C57', '%23060D5E',
            '%23113F47', '%237A367A', '%235229A3', '%23865A5A', '%23705770',
            '%2323164E', '%235B123B', '%2342104A', '%23875509', '%238D6F47',
            '%236B3304', '%23333333']

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
    calendar = Google::Apis::CalendarV3::Calendar.new(summary: name,
                                                      time_zone: "America/New_York")
    result = service.insert_calendar(calendar)
    return result.id
  end
  
  # create an event on the given google calendar
  def self.add_event(token, calendar_id, title, start_dt, end_dt)
    access_token = AccessToken.new token
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = access_token
    event = Google::Apis::CalendarV3::Event.new(
      summary: title,
      description: title,
      start: { date_time: start_dt,
               time_zone: "America/New_York" },
      end: { date_time: end_dt,
             time_zone: "America/New_York" })
    result = service.insert_event(calendar_id, event)
    return result.id
  end
  
  # return the URL provided by google for the iframe needed to embed a google
  # calendar on our site. Show all calendars
  def self.url(signed_in)
    cals_src = ""
    color = 0
    CucoSession.find_each do |cuco_session|
      if cuco_session.dates != nil
        # include all calendars if the user is signed in, otherwise only if the
        # calendar is public
        cals_src += cal_src(cuco_session.dates.public_calendar_gid, COLORS[color])
        color = next_color(color)
        if (signed_in) then
          cals_src += cal_src(cuco_session.dates.member_calendar_gid, COLORS[color])
          color = next_color(color)
        end
      end
    end
    "https://calendar.google.com/calendar/embed?title=CUCO%20Calendar&height=600&wkst=1&bgcolor=%23FFFFFF&#{cals_src}ctz=America%2FNew_York"
  end

  private
    # return the code that google needs included in the iframe for each google calendar,
    # given a calendar id (a string of characters provided by google) and a color
    def self.cal_src(id, color)
      "src=#{id}&color=#{color}&"
    end

    # get the next color to use for a calendar
    # increment color by more than 1 each time since adjacent colors are similar
    def self.next_color(color)
      color += 10
      if color >= COLORS.length then color -= COLORS.length end
      color
    end
end