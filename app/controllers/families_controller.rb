class FamiliesController < ApplicationController
  let :web_team, :all
  let :web_team, [:manage_all, :edit_primary]
  let :user, [:show, :new, :create, :edit, :update]
  let [:member, :paid], :show_member_directory
  
  before_action :set_family, except: [:new, :create, :index, :show_emergency_contacts, :show_member_directory]
  before_action :must_have_no_family, only: [:new, :create]
  before_action :must_be_my_family, only: [:show, :edit, :update, :destroy]
  before_action :set_current_families, only: [:show_emergency_contacts, :show_member_directory]

  def index
    @families = Family.paginate(page: params[:page])
  end

  def show
    @families = Family.all
  end

  def new
    @family = Family.new
    @family.state = "OH"
    @person = Person.new
    @users = User.where(person_id: nil).order(:email)
  end

  def edit
  end

  def create
    @family = Family.new(family_params)
    @person = Person.new(person_params)
    if @family.valid? and @person.valid?
      @family.save
      @person.family_id = @family.id

      @person.user = User.find(params["family"]["person"]["user"])

      @person.save
      @family.primary_adult_id = @person.id
      @family.save
      # let the user know what we just did
      redirect_to @family, notice: "#{@family.name} was successfully created."
    else
      render :new
    end
  end

  def update
    if @family.update(family_params)
      redirect_to @family, notice: "#{@family.name} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @family.destroy
    redirect_to families_url, notice: "#{@family.name} was successfully destroyed."
  end

  def show_member_directory
  end

  def show_emergency_contacts
  end

  private
    # throw an error if this is not the current user's family
    # unless this user is exempt
    def must_be_my_family
      unless (current_user&.person&.family == @family or
              current_user&.can? :manage_all, :families)
        not_authorized! path: families_path, message: "That's not your family!"
      end
    end
  
    # throw an error if the current user already has a family
    def must_have_no_family
      unless (current_user&.person&.family.nil? or
              current_user&.can? :manage_all, :families)
        not_authorized! path: families_path, message: "You already have a family!"
      end
    end

    # Get list of families for the directory
    # if there is a current session, families in it will be included
    # if there is an upcoming session, families in it will be included
    # if there is no current or upcoming, families in the latest session
    #   will be included
    def set_current_families
      if !CucoSession.current and !CucoSession.upcoming then
        @families = CucoSession.latest.families.order(:name)
      elsif CucoSession.current and CucoSession.upcoming then
        @families = CucoSession.current.families +
                    CucoSession.upcoming.families
        @families.sort_by{|family| family.name}
      elsif CucoSession.upcoming then
        @families = CucoSession.upcoming.families.order(:name)
      else
        @families = CucoSession.current.families.order(:name)
      end
      @families = @families.uniq
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_family
      @family = Family.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_params
      params.require(:family).permit(:name, :street_address, :city, :state,
                                     :zip, :phone, :text, :primary_adult_id,
                                     :ec_first_name, :ec_last_name, :ec_phone,
                                     :ec_text, :ec_relationship)
    end

    def person_params
      params.require(:family).require(:person).permit(:first_name, :last_name, :pronoun_id)
    end
end
