class HomeController < ApplicationController

  def autocomplete
    params[:term].downcase!
    fields = current_fields_of_study.values.map(&:downcase).grep /#{params[:term]}/
    render json: fields.map(&:titleize)
  end
  
  def wide_search
    @search = params[:search]
    @parts = Refinery::PagePart.includes(:page).search(@search, :autocomplete => false,:fields => [:body], :highlight => true)
    @projects = Project.search(@search, :autocomplete => false,:fields => [:name, :description], :highlight => true)
  end
  
  def elastic_autocomplete
    @search = params[:term]
    parts = Refinery::PagePart.search(@search, :autocomplete => false,:fields => [:body], :highlight => true).map(&:title)
    projects = Project.search(@search, :autocomplete => false,:fields => [:name], :highlight => true).map(&:name)
    render json: parts+projects
  end
  
end