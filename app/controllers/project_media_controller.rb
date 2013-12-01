class ProjectMediaController < ApplicationController
  respond_to :js

  load_and_authorize_resource

  def create
    @project = Project.find(params[:project_id])
    @project_media = @project.project_media.create(params[:project_media])
    respond_with(@project_media)
  end
  def destroy
    @project_media = ProjectMedia.find(params[:id])
    @project_media.destroy
    respond_to do |format|
      format.js {render :nothing => true}
    end
  end
end