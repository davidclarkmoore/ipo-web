class ProjectsController < ApplicationController
  respond_to :html, :js

  def index
    @search = Project.search(params[:q])
    @projects = @search.result
    @projects.concat(Project.related_to_fields_of_study?(params[:properties_fields])) if params[:properties_fields]
    @projects.concat(Project.related_student_passions?(params[:properties_passions])) if params[:properties_passion]
    @total_projects = @projects.count
 
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
