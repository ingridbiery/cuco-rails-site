class UsersController < ApplicationController
  let :admin, :index
  let :all, [:show, :edit, :delete] # we will restrict in show to only show own user
  before_action :set_user, only: [:show, :edit, :update, :destroy]
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

  # GET /users/1/edit
  def edit
    # only show the user if it is the current user
    unless params[:id].to_i == current_user.id
      not_authorized! path: root_path, message: "That's not you!"
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
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

    # Only allow a trusted parameter "white list" through.
    def user_params
      params[:user].permit(:email)
    end
end
