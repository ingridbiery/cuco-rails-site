class PeopleController < ApplicationController
  let :web_team, :all
  let :web_team, :access_any_family
  let [:user, :member], [:show, :new, :create, :edit, :update]
  before_action :set_family
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  # GET /families/:family_id/people
  def index
    @people = @family.people.all
  end

  # GET /families/:family_id/people/1
  def show
  end

  # GET /families/:family_id/people/new
  def new
    @person = @family.people.build
    # this person is not the current user (at least not yet)
    @this_is_me = false
  end

  # GET /families/:family_id/people/1/edit
  def edit
    # set a boolean based on whether this person has an associated user
    # (there is a checkbox on the form)
    @this_is_me = (@person.user != nil)
  end

  # POST /families/:family_id/people
  def create
    @person = @family.people.build(person_params)

    if @person.save
      tell_user = "#{@person.name} was successfully created."
      # if this person is me, connect the user and the person
      if params[:this_is_me]
        # update the person's user
        @person.user = current_user
        tell_user += " #{@person.name} is the user for this family."
        # if there was not already a primary adult, make this the primary
        if @family.primary_adult_id == nil
          @family.primary_adult_id = @person.id
          @family.save
          tell_user += " #{@person.name} is the primary adult for this family."
        end
      end
      redirect_to family_person_path(@family, @person), notice: tell_user
    else
      render :new
    end
  end

  # PATCH/PUT /families/:family_id/people/1
  def update
    if @person.update(person_params)
      # if the person is now me, make sure the person's user is the current user
      # (it may have already been set)
      if (params[:this_is_me])
        @person.user = current_user
      else # the person is not me
        # if this was the current user's person, update
        if current_user.person == @person
          @person.user = nil
        end
      end
      redirect_to family_person_path(@family, @person), 
                  notice: "#{@person.name} was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /families/:family_id/people/1
  def destroy
    # if we're destroying the primary adult, make sure the family knows
    if (@person.id == @family.primary_adult_id)
      @family.primary_adult_id = nil
      @family.save
    end
 
    @person.destroy
    redirect_to family_path(@family), 
        notice: "#{@person.name} was successfully destroyed."
  end

  private
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
