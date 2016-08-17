class RoomsController < ApplicationController
  let :web_team, [:index, :edit, :update]
  before_action :set_room, only: [:edit, :update]
  before_action :authenticate_user!

  def index
    @rooms = Room.all
  end

  def edit
  end

  def update
    if @room.update(room_params)
      redirect_to rooms_path, notice: "#{@room.name} was successfully updated."
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end
end
