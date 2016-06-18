class CucoSessionsController < ApplicationController
  let :admin, [:new, :add_event, :confirm_dates]
  
  def new
  end

  # add a random event to a random google calendar (the first one in our database)
  # proof of concept only -- not a meaningful event yet
  def add_event
    @event = {
      'summary' => 'New Event Title',
      'description' => 'The description',
      'location' => 'Location',
      'start' => { 'dateTime' => DateTime.now },
      'end' => { 'dateTime' => DateTime.now + 1.hour }}
  
    client = Google::APIClient.new(:application_name => Workspace::GOOGLE_APPLICATION_NAME,
                                   :application_version => Workspace::GOOGLE_APPLICATION_VERSION)
    client.authorization.access_token = current_user.token
    service = client.discovered_api('calendar', 'v3')

    @set_event = client.execute(:api_method => service.events.insert,
                                :parameters => {'calendarId' => Calendar.first.googleid,
                                                'sendNotifications' => false},
                                :body => JSON.dump(@event),
                                :headers => {'Content-Type' => 'application/json'})
    redirect_to calendar_path
  end
  
  def confirm_dates
    @session_name = params[:session_name]
    @tuesdays = calculate_tuesdays(params[:start_date], params[:end_date])
  end

  private
    # get the dates of all the Tuesdays between two dates
    def calculate_tuesdays start_date, stop_date
      day = Date.parse(start_date)
      stop = Date.parse(stop_date)
      # find the first Tuesday (day number 2)
      while day.wday != 2 do day += 1 end
      tuesdays = [day] if day < stop
      while day < stop do
        day += 7
        tuesdays.append(day)
      end
      tuesdays
    end

end
