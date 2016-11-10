class PeopleController < ApplicationController
  let :web_team, :all
  # everyone with an account is a :user, often in addition to other roles
  # regular people cannot destroy people, even their own
  let [:user], [:show, :new, :create, :edit, :update]

  before_action :set_family
  before_action :set_person, only: [:show, :edit, :update, :destroy]
  
  # make sure people don't mess with people who are not in their family
  before_action :must_be_in_my_family, only: [:new, :create, :show, :edit, :update, :destroy]
  # don't let primary adults or people associated with users be destroyed
  before_action :must_be_available_for_destruction, only: :destroy

  def index
    @people = @family.people.all
  end

  def show
  end

  def new
    @person = @family.people.build
  end

  def edit
  end

  def create
    @person = @family.people.build(person_params)

    if @person.save
      redirect_to family_person_path(@family, @person), notice: "#{@person.name} was successfully created."
    else
      render :new
    end
  end

  def update
    if @person.update(person_params)
      redirect_to family_person_path(@family, @person), 
                  notice: "#{@person.name} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @person.destroy
    redirect_to family_path(@family), 
                notice: "#{@person.name} was successfully destroyed."
  end

  private
  
    # don't allow if this is not part of the current user's family
    # unless this user is exempt
    def must_be_in_my_family
      unless (current_user&.person&.family == @family or
              current_user&.can? :manage_all, :families)
        not_authorized! path: families_path, message: "That person is not in your family!"
      end
    end

    # don't let the primary adult for a family or a person associated with a user
    # be destroyed
    def must_be_available_for_destruction
      if @person.family.primary_adult == @person
        not_authorized! path: families_path, message: "That person is a primary adult and can't be destroyed!"
      elsif @person.user
        not_authorized! path: families_path, message: "That person is associated with a user and can't be destroyed!"
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end
    
    # get the family from params before doing anything else
    def set_family
      @family = Family.find(params[:family_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:first_name, :last_name, :dob,
                                     :family_id, :pronoun_id,
                                     :social_media)
    end
end
