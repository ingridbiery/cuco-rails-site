class PronounsController < ApplicationController
  before_action :set_pronoun, only: [:show, :edit, :update, :destroy]

  def index
    @pronouns = Pronoun.all
  end

  def show
  end

  def new
    @pronoun = Pronoun.new
  end

  def edit
  end

  def create
    @pronoun = Pronoun.new(pronoun_params)
    if @pronoun.save
      redirect_to pronouns_path, notice: "#{@pronoun.preferred_pronouns} was successfully created."
    else
      render :new
    end
  end

  def update
    if @pronoun.update(pronoun_params)
      redirect_to pronouns_path, notice: "#{@pronoun.preferred_pronouns} was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @pronoun.destroy
    redirect_to pronouns_path, notice: "#{@pronoun.preferred_pronouns} was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pronoun
      @pronoun = Pronoun.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pronoun_params
      params.require(:pronoun).permit(:preferred_pronouns)
    end

end
