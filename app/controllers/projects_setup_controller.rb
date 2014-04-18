class ProjectsSetupController < ApplicationController
  before_filter :check_step, :clean_select_multiple_params
  include Wicked::Wizard
  steps :about_you, :the_project, :location, :content, :agreement, :confirmation

  def show
    @project = current_project
    case step
    when :about_you
      @project.build_field_host unless @project.field_host
      @project.build_organization unless @project.organization
      @project.field_host.build_login unless @project.field_host && @project.field_host.login
    when :the_project
      @project.project_sessions.build if @project.project_sessions.empty?
    end
    flash[:editing_mode] = @project.complete? # For editing projects 
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
    if step == :agreement || @project.complete?
      params[:project][:wizard_status] = Project::COMPLETE 
      @project.status = Project::COMPLETE
    end

    if @project.update_attributes(params[:project])
      create_login_session unless login_signed_in?
    end

    if params[:save_and_finish] && @project.save
      session[:project_id] = nil
      # create/update SF object
      ProjectSyncWorker.perform_async(@project.id)
      redirect_to dashboards_path
    else
      render_wizard @project
      session[:project_id] = @project.id
      if step == :agreement
        session[:project_id] = nil 
      end
      # create/update SF object
      ProjectSyncWorker.perform_async(@project.id) if step == :agreement || @project.complete?
    end
  end


  def application_deadline
    @session = Session.find(params[:id])
    respond_to do |format|
      format.json { render json: @session.application_deadline }
    end
  end

  private

  def current_project
    @current_project ||= begin
      project = session[:project_id] && Project.find_by_id(session[:project_id])
      project ||= associate_to_fieldhost
    end
  end

  def associate_to_fieldhost
    return Project.new unless current_fieldhost
    Project.new(field_host_id: current_fieldhost.id)
  end

  def create_login_session
    sign_in @current_project.field_host.login
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
