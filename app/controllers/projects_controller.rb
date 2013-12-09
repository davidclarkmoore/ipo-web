class ProjectsController < ApplicationController
  respond_to :html, :js

  def index
    #binding.pry
    @search = Project.search(params[:q])
    @projects = @search.result(distinct: true)
    @total_projects = Project.all.count
    
    params[:view] ||= 'grid'
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params[:project])
    flash[:notice] = "Project was successfully created." if @project.save
    respond_with(@project) do |format|
      format.html { redirect_to projects_path }
    end
  end

end
