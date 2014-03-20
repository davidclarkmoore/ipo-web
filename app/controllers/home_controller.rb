class HomeController < ApplicationController

  def autocomplete
    params[:term].downcase!
    fields = current_fields_of_study.values.map(&:downcase).grep /#{params[:term]}/
    render json: fields.map(&:titleize)
  end
end