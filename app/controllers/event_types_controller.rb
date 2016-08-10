class EventTypesController < ApplicationController
  let :web_team, :all
  before_action :set_event_type, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @event_types = EventType.all
  end

  def show
  end

  def new
    @event_type = EventType.new
  end

  def edit
  end

  def create
    @event_type = EventType.new(event_type_params)
    if @event_type.save
      redirect_to event_type_path, notice: "#{@event_type.name} was successfully created."
    else
      render :new
    end
  end

  def update
    if @event_type.update(event_type_params)
      redirect_to event_type_path, notice: "#{@event_type.name} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @event_type.destroy
    redirect_to event_types_path, notice: "#{@event_type.name} successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_type
      @event_type = EventType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_type_params
      params.require(:event_type).permit(:name, :display_name, :start_date_offset,
                                         :end_date_offset, :start_time, :end_time,
                                         :members_only, :registration)
    end

end
