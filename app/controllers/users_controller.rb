class UsersController < ApplicationController
  let :admin, :index
  let :all, [:show, :edit, :destroy] # we will restrict in show to only show own user
  before_action :set_user, only: [:show, :destroy]
  before_action :authenticate_user!
  
  # GET /users
  def index
    @users = User.paginate(page: params[:page])
  end

  # GET /users/1
  def show
    # only show the user if it is the current user
    unless params[:id].to_i == current_user.id
      not_authorized! path: root_path, message: "That's not you!"
    end
  end

  # DELETE /users/1
  def destroy
    # only show the user if it is the current user
    unless params[:id].to_i == current_user.id
      not_authorized! path: root_path, message: "That's not you!"
    else
      @user.destroy
      redirect_to users_url, notice: 'User was successfully destroyed.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    
    # trusted params are handled in the application controller since we don't
    # do new/create edit/update here
end
