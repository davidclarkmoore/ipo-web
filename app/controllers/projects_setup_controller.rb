class ProjectsSetupController < ApplicationController
  include Wicked::Wizard
  steps :about_you, :the_project, :location, :content, :agreement, :confirmation

  before_filter :check_step

  def show
    @project = current_project
    case step
    when :about_you
      @project.build_field_host unless @project.field_host
      @project.build_organization unless @project.organization
    end
    render_wizard
  end

  def update
    @project = current_project
    @project.update_attributes params[:project]
    render_wizard @project
    session[:project_id] = @project.id
  end

  private
  def current_project
    @current_project ||= begin
      project = session[:project_id] && Project.find_by_id(session[:project_id])
      project ||= Project.new
    end
  end
  def check_step
    # TODO: Add a validation to make sure user isn't skipping ahead
  end
end
