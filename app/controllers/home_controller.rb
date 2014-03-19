class HomeController < ApplicationController
  layout 'home'

  def index
    @fields_of_study = Project.related_fields_of_study.values
    @student_passions = Project.related_student_passions.values
  end

  def autocomplete
    params[:term].downcase!
    fields = current_fields_of_study.values.map(&:downcase).grep /#{params[:term]}/
    render json: fields.map(&:titleize)
  end
end