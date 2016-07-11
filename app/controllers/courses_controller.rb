class CoursesController < ApplicationController

  def new
    @course = Course.new
  end

  def edit
  end

  private

    def set_family
      @course = Course.find(params[:id])
    end

    def family_params
      params.require(:course).permit(:title, :short_title, :description, :min_age,
                                     :max_age, :age_firm, :min_num_students,
                                     :max_num_students, :course_fee, :supplies,
                                     :room_requirements, :time_requirements,
                                     :drop_ins, :additional_info)
    end

end
