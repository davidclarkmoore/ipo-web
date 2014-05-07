class HomeController < ApplicationController

  def autocomplete
    params[:term].downcase!
    fields = current_fields_of_study.values.map(&:downcase).grep /#{params[:term]}/
    render json: fields.map(&:titleize)
  end
  
  def wide_search
    @search = params[:search]
    @pages = Refinery::Page.search(@search, :autocomplete => false,:fields => [:title, :bodies], :highlight => true)
    @projects = Project.search(@search, :autocomplete => false,:fields => [:name, :description], :highlight => true)
  end
  
  def elastic_autocomplete
    @search = params[:term]
    pages = Refinery::Page.search(@search, :autocomplete => true,:fields => [:title], :highlight => false).map(&:title)
    projects = Project.search(@search, :autocomplete => true,:fields => [:name], :highlight => false).map(&:name)
    render json: pages+projects
  end
  
end