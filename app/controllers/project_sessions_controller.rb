class ProjectSessionsController < ApplicationController
  load_and_authorize_resource
  respond_to :html, :js
 
  def index
    @project_session = ProjectSession.all
  end

  def new
    @project_session = ProjectSession.new
  end

  def create
    @project_session = ProjectSession.new(params[:project_session])
    flash[:notice] = "Project was successfully created." if @project_session.save
    respond_with(@project_session) do |format|
      format.html { redirect_to project_sessions_path }
    end
  end

end
