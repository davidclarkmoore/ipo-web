class ProjectsController < ApplicationController
  before_filter :authenticate_login!, :only => [:new, :create]
  before_filter :convert_to_datetime, :validate_home_search, :only => [:index]
  respond_to :html, :js

  def index
    projects = ProjectLoader.load_projects(params[:properties])
    @projects = projects.completed.ransack(params[:q])
    @total_projects = @projects.result.count
    @sessions = Session.order(:start_date)
    params[:view] ||= 'grid'
    params[:order] ||= 'name'
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

  def edit
    authorize! :edit, Project.find(params[:id])
    session[:project_id] = params[:id]
    session[:editing_project] = true
    redirect_to projects_setup_path(:about_you)
  end

  def show
    @p = Project.find(params[:id])
    @project_media = ProjectMedia.where(params[:project])
    @host = FieldHost.find(Project.find(params[:id]).field_host_id)
  end

  def sync_with_sf
    begin
      sf_project = Project.sf.find_by_id(params[:sf_object_id])
      sf_field_host = FieldHost.sf.find_by_id(sf_project.FieldHost__c) 
      sf_organization = Organization.sf.find_by_id(sf_project.Organization__c)
      ActiveRecord::Base.transaction do
        sf_project.save_to_rails!
        sf_field_host.save_to_rails! if sf_field_host
        sf_organization.save_to_rails! if sf_organization
      end
      render json: sf_project
    rescue => e
      render json: { error: e.message }, status: 400
    end
  end

  private

  def validate_home_search
    return if params[:related_field_of_study].blank?
    field = params[:related_field_of_study]

    params[:properties] = {}
    params[:properties][:related_fields_of_study] = current_fields_of_study.invert[field].to_s.split
    @field_of_study = params[:properties][:related_fields_of_study]
    @name_or_address = params[:q][:name_or_address_cont]
  end


  def convert_to_datetime
    return unless params[:q].present?
    params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day if params[:q][:created_at_gt].present?
    params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day if params[:q][:created_at_lt].present?
  end
end
