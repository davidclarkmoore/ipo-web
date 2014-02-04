class DashboardsController < ApplicationController
   respond_to :html

  def index
    if current_login.entity_type == "FieldHost"
      redirect_to(action: 'fieldhost')
    else
      redirect_to(action: 'student')
    end
  end

  def fieldhost
    @fieldhost = FieldHost.find(current_login.entity_id)
    @project_sessions = @fieldhost.project_sessions

    params[:view] ||= "dashboard"
    render "dashboards/fieldhost/index"
  end

  def student
    @student = Student.find(current_login.entity_id)
    @student_application = @student.student_applications.first

    params[:view] ||= "dashboard"
    render "dashboards/student/index"
  end

  def update_fieldhost
    @fieldhost = FieldHost.find(params[:id])

    notice = @fieldhost.update_attributes(params[:field_host]) ? "Fieldhost was successfully updated." : "There was some problem with your data, please review"
    respond_with(@fieldhost) do |format|
      format.html { redirect_to dashboards_fieldhost_path(view: 'settings'), notice: notice }
    end

  end

  def update_student
    @student = Student.find(params[:id])

    notice = @student.update_attributes(params[:student]) ? "Student was successfully updated" : "There was some problem with your data, please review"
    respond_with(@fieldhost) do |format|
      format.html { redirect_to dashboards_student_path(view: params[:view]), notice: notice }
    end
  end
end