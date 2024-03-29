class UsersController < ApplicationController
  let [:web_team, :new_member_coordinator], [:index, :manage_all, :show_notification_list]
  let :all, [:show, :edit, :destroy] # we will restrict in show to only show own user
  
  # this is probably not the best place for this, but we don't have access to the
  # high_voltage controller, and putting a let statement in the ApplicationController
  # doesn't work (creates a redirect loop)
  let [:member, :paid, :former], [:show_concern_process, :show_hardship_pass, :show_all_faqs]
  
  before_action :set_user, only: [:show, :destroy]
  before_action :must_be_me, only: [:show, :destroy]

  # GET /users
  def index
    @users = User.order('email')
  end

  # GET /users/1
  def show
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  # GET /users/notification_list
  def show_notification_list
    @users = User.order('email').where(notification_list: true)
  end

  private
  
    # call not_authorized with a message if the user tries to access someone
    # else's user information
    def must_be_me
      unless (current_user == @user or
              current_user&.can? :manage_all, :users)
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
