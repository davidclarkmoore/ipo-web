class ProjectsController < ApplicationController
  respond_to :html, :js

  def index
    projects = ProjectLoader.load_projects(params[:properties])
    @projects = projects.search(params[:q])
    @total_projects = @projects.result.count
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
