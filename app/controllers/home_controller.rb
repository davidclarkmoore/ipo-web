class HomeController < ApplicationController
  layout 'home'
  
  def index
  end

  def autocomplete
    fields = I18n.t("enumerize.project.related_fields_of_study").values.grep /#{params[:term]}/
    render json: fields
  end
end