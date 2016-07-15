class FamiliesController < ApplicationController
  before_action :set_family, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /families
  # GET /families.json
  def index
    @families = Family.paginate(page: params[:page])
  end

  # GET /families/1
  # GET /families/1.json
  def show
    @family = Family.find(params[:id])
    @people = @family.people
    @families = Family.all
  end

  # GET /families/new
  def new
    @family = Family.new
    @family.state = "OH"
  end

  # GET /families/1/edit
  def edit
    @people = @family.people
  end

  def create
    @family = Family.new(family_params)
    if @family.save
      first_person = @family.people.create!(first_name: current_user.first_name,
                                            last_name: current_user.last_name)
      @family.primary_adult = first_person.id
      @family.save
      redirect_to @family, notice: "#{@family.name} was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /families/1
  # PATCH/PUT /families/1.json
  def update
    if @family.update(family_params)
      redirect_to @family, notice: "#{@family.name} was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /families/1
  # DELETE /families/1.json
  def destroy
    @family.destroy
    redirect_to families_url, notice: "#{@family.name} was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_family
      @family = Family.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_params
      params.require(:family).permit(:name, :street_address, :city, :state,
                                     :zip, :primary_adult)
    end
end
