class ProjectsSetupController < ApplicationController
  include Wicked::Wizard
  steps :about_you, :the_project, :location, :content, :agreement, :confirmation

  before_filter :check_step
  before_filter :clean_select_multiple_params

  def show
    @project = current_project
    case step
    when :about_you
      @project.build_field_host unless @project.field_host
      @project.build_organization unless @project.organization
    end
    @project.wizard_status = step.to_s # For client-side validations
    render_wizard
  end

  def update
    @project = current_project

    case step
    when :about_you
      if params[:is_new_organization] == "true"
        params[:project].delete(:organization_id)
        @project.build_organization
      else
        params[:project].delete(:organization_attributes)
      end
    end

    params[:project][:wizard_status] = step.to_s
    params[:project][:wizard_status] = 'complete' if step == steps.last

    

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

  def clean_select_multiple_params hash = params
    hash.each do |k, v|
      case v
      when Array then v.reject!(&:blank?)
      when Hash then clean_select_multiple_params(v)
      end
    end
  end
end
