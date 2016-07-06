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
  end

  # GET /families/:family_id/people/1/edit
  def edit
  end

  # POST /families/:family_id/people
  def create
    @person = @family.people.build(person_params)

    if @person.save
      redirect_to family_person_path(@family, @person),
          notice: "#{@person.first_name} #{@person.last_name} was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /families/:family_id/people/1
  def update
    if @person.update(person_params)
      redirect_to family_person_path(@family, @person), 
          notice: "#{@person.first_name} #{@person.last_name} was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /families/:family_id/people/1
  def destroy
    @person.destroy
    redirect_to family_path(@family), 
        notice: "#{@person.first_name} #{@person.last_name} was successfully destroyed."
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
                                     :primary_adult, :family_id, :pronoun_id,
                                     :email, :phone, :social_media)
    end
end
