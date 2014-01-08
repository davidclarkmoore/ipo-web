class HomeController < ApplicationController
  layout 'home'
  
  def index
  end

  def autocomplete
    fields = current_fields_of_study.values.grep /#{params[:term]}/
    render json: fields
  end
end