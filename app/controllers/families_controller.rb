class FamiliesController < ApplicationController
  let :member, :all
  let :web_team, :all
  let :user, [:show, :new, :create, :update]
  before_action :set_family, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /families
  def index
    @families = Family.paginate(page: params[:page])
  end

  # GET /families/1
  def show
    @family = Family.find(params[:id])
    @families = Family.all

    if current_user.person != nil then
      family_id = current_user.person.family_id
    end

    is_this_my_family(family_id)
  end

  # GET /families/new
  def new
    @family = Family.new
    @family.state = "OH"
    @person = Person.new
  end

  # GET /families/1/edit
  def edit
    if current_user.person != nil then
      family_id = current_user.person.family_id
    end

    is_this_my_family(family_id)
  end

  def create
    byebug
    @family = Family.new(family_params)
    @person = Person.new(people_params)
    if @family.save
      @family.primary_adult_id = @family.person.first.id
      @family.save
      # let the user know what we just did
      redirect_to @family, notice: "#{@family.name} was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /families/1
  def update
    if @family.update(family_params)
      redirect_to @family, notice: "#{@family.name} was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /families/1
  def destroy
    @family.destroy
    redirect_to families_url, notice: "#{@family.name} was successfully destroyed."
  end

  # only show the family if it is the current user's family or
  # the current user and family are available for an association
  def is_this_my_family(family_id)
    unless params[:id] == family_id.to_s or
      (family_id == nil and @family.user == nil) or
      current_user.can? :index, UsersController
    not_authorized! path: families_path, message: "That's not your family!"
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_family
      @family = Family.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_params
      params.require(:family).permit(:name, :street_address, :city, :state,
                                     :zip, :primary_adult_id, :ec_first_name,
                                     :ec_last_name, :ec_phone, :ec_text,
                                     :ec_relationship)
    end
end
