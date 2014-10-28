class HomeController < ApplicationController

  def autocomplete
    params[:term].downcase!
    fields = current_fields_of_study.values.map(&:downcase).grep /#{params[:term]}/
    render json: fields.map(&:titleize)
  end
  
  def wide_search
    @search = params[:search]
    @pages = Refinery::Page.search(@search, :autocomplete => false, :fields => [:title, :bodies], :highlight => true, 
      :where => { show_in_menu: true, draft: false})
    
    #this hack solves the problem with enumerized status, 
    #since where: { status: 'approved'} was not returning any result
    @projects = Project.search(@search, :autocomplete => false, :fields => [:name, :description], :highlight => true,
      :where => { id: { in: project_approved_ids }})  
  end
  
  def elastic_autocomplete
    @search = params[:term]
    pages = Refinery::Page.search(@search, :autocomplete => true,:fields => [:title], :highlight => false, 
      :where => { show_in_menu: true, draft: false}).map(&:title)
    
    #this hack solves the problem with enumerized status, 
    #since where: { status: 'approved'} was not returning any result
    projects = Project.search(@search, :autocomplete => true,:fields => [:name], :highlight => false,
      :where => { id: { in: project_approved_ids }}).map(&:name)
    render json: pages+projects
  end

  def project_approved_ids
    @ids ||= Project.approved.pluck(:id)
  end
end