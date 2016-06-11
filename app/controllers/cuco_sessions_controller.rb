class CucoSessionsController < ApplicationController
  let :admin, [:new, :add_event]
  
  def new
  end

  def add_event
    @event = {
      'summary' => 'New Event Title',
      'description' => 'The description',
      'location' => 'Location',
      'start' => { 'dateTime' => DateTime.now },
      'end' => { 'dateTime' => DateTime.now + 1.hour }}
  
    client = Google::APIClient.new(:application_name => "ib-calendar-test",
                                   :application_version => "1.0")
    client.authorization.access_token = current_user.token
    service = client.discovered_api('calendar', 'v3')

    @set_event = client.execute(:api_method => service.events.insert,
                                :parameters => {'calendarId' => Calendar.first.googleid,
                                                'sendNotifications' => false},
                                :body => JSON.dump(@event),
                                :headers => {'Content-Type' => 'application/json'})
    redirect_to calendar_path
  end
end
