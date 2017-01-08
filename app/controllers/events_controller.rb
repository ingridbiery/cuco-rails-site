class EventsController < ApplicationController

  let :web_team, :all
  let :user, :show
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  
  def show
  end
  
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to calendar_path, notice: "#{@event.name} was successfully created."
    else
      render :new
    end
  end

  def update
    if @event.update(event_params)
      redirect_to calendar_path, notice: "#{@event.name} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to calendar_path, notice: "#{@event.name} was successfully deleted."
  end

  private

    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:id, :name, :start_dt, :end_dt, :event_type_id)
    end

end