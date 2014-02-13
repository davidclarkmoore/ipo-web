class DashboardsController < ApplicationController
  before_filter :authenticate_login!
  respond_to :html

  def index
    @login = current_login.entity
    @student_application = @login.student_applications.active.last if @login.class.name == "Student"
    params[:view] ||= "dashboard"
  end

  def update_login
    @login = current_login.entity
    param = @login.class.name == "FieldHost" ? :field_host : :student

    respond_to do |format|
      notice =  @login.update_attributes(params[param]) ? "Success" : "Error"
      format.html { redirect_to dashboards_path(view: params[:view], notice: notice) }
    end
  end
end