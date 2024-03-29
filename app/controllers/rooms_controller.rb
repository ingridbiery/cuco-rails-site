class RoomsController < ApplicationController
  let :web_team, [:index, :edit, :update]
  before_action :set_room, only: [:edit, :update]

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
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name)
    end

end
