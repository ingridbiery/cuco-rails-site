class PronounsController < ApplicationController
  before_action :set_pronoun

  def index
    @pronouns = @pronoun.all
  end

  def show
  end

  def new
    @pronoun = Pronoun.new
  end

  def edit
    @pronoun = Pronoun.find(params[:id])
  end

  def create
    @pronoun = Pronoun.new(pronoun_params)

    respond_to do |format|
      if @pronoun.save
        format.html { redirect_to pronouns_path, :notice => "#{@pronoun.pronouns} were successfully created." }
        format.json { render :show, status: :created, location: @pronoun }
      else
        format.html { render :new }
        format.json { render json: @pronoun.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @pronoun.update(pronoun_params)
        format.html { redirect_to pronouns_path, :notice => "#{@pronoun.pronouns} were successfully updated." }
        format.json { render :show, status: :ok, location: @pronoun }
      else
        format.html { render :edit }
        format.json { render json: @pronoun.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @pronoun = Pronoun.find(params[:id])
    @pronoun.destroy
    respond_to do |format|
      format.html { redirect_to pronouns_path, :notice => "#{@pronoun.pronouns} were successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pronoun
      @pronoun = Pronoun.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pronoun_params
      params.require(:pronoun).permit(:pronouns)
    end

end
