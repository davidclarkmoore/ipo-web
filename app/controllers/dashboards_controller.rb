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

    if @fieldhost.update_attributes(params[:field_host])
      flash[:notice] = "Fieldhost was successfully updated." 
    else
      flash[:error] = "There was some problem with your data, please review" 
    end

    respond_with(@fieldhost) do |format|
      format.html { redirect_to(action: 'fieldhost', view: 'settings') }
    end
  end
end