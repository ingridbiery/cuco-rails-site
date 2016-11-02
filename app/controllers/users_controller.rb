class UsersController < ApplicationController
  let :web_team, :index
  let :all, [:show, :edit, :destroy] # we will restrict in show to only show own user
  before_action :set_user, only: [:show, :destroy]
  before_action :must_be_me, only: [:show, :destroy]

  # GET /users
  def index
    @users = User.paginate(page: params[:page])
  end

  # GET /users/1
  def show
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
  
    # call not_authorized with a message if the user tries to access someone
    # else's user information
    def must_be_me
      unless @user == current_user
        not_authorized! path: root_path, message: "That's not you!"
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    
    # trusted params are handled in the application controller since we don't
    # do new/create edit/update here
end
