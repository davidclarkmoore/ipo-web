class ProjectsController < ApplicationController
  respond_to :html, :js
  before_filter :convert_to_datetime, :only => [:index]

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

  private

  def convert_to_datetime
    return unless params[:q].present?
    params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day if params[:q][:created_at_gt].present?
    params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day if params[:q][:created_at_lt].present?
  end
end
