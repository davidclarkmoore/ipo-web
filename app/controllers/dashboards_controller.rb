class DashboardsController < ApplicationController
  before_filter :authenticate_login!
  respond_to :html

  def index
    @login = current_login

    student_index if current_login.student?
    field_host_index if current_login.field_host?

    params[:view] ||= "dashboard"
  end

  def update_login
    @login = current_login.entity
    param = is_fieldhost? ? :field_host : :student

    respond_to do |format|
      notice =  @login.update_attributes(params[param]) ? "Success" : "Error"
      format.html { redirect_to dashboards_path(view: params[:view], notice: notice) }
    end
  end

  private

  def student_index
    @student = @login.entity
    @student_application = @login.student_applications
  end

  def field_host_index
    @field_host = @login.entity
  end

end