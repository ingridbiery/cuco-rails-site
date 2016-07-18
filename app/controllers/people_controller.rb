class PeopleController < ApplicationController
  before_action :set_family
  before_action :set_person, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

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
        # update the current user's person
        update_person(@person)
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
        update_person(@person)
      else # the person is not me
        update_person(nil)
      end
      redirect_to family_person_path(@family, @person), 
          notice: "#{@person.name} was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /families/:family_id/people/1
  def destroy
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

    # update the person for the current user (this is a two-way link -- make sure to break
    # the old link if it exists, from the other side). This wasn't working with setting
    # the user or person directly, but seems to work with setting the ids. I don't know why
    def update_person new_person
      # save the old person (may be nil) (trying to update now from the person doesn't work)
      old_person_id = current_user.person_id

      # if there is no change, don't waste our time
      if old_person_id == new_person.id
        return
      end

      # update the user's person
      current_user.person_id = new_person.id
      current_user.save

      # update the person's user (don't know why this isn't happening automatically)
      new_person.user_id = current_user.id
      new_person.save

      # clean up old_person's reference to current_user, if needed
      if old_person_id != nil
        old_person = Person.find(old_person_id)
        old_person.user_id = nil
        old_person.save
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:first_name, :last_name, :dob,
                                     :family_id, :pronoun_id,
                                     :email, :phone, :social_media)
    end
end
