class CalendarsController < ApplicationController

  def show
    @calendar_src = Calendar.new(user_signed_in?).url
    # since we don't explicitly render a template,
    # Rails renders views/calendars/show.html.erb (because our controller is
    # calendars and our action is show)
  end
  
end
