class StudentsSetupController < ApplicationController
  before_filter :authenticate_login!, :set_student_application, :clean_select_multiple_params
  before_filter :update_wizard_status, only: :update
  include Wicked::Wizard  
  steps :about_you, :interests_and_fields_of_study, :important_details, :confirmation
  

  def show
    @student_application.build_student unless @student_application.student
    case step
    when :about_you
      @student_application.student.build_login unless @student_application.student && @student_application.student.login
    when :interests_and_fields_of_study
      @student_application.student.build_spiritual_reference unless @student_application.student.spiritual_reference
      @student_application.student.build_academic_reference unless @student_application.student.academic_reference
    end
    @student_application.wizard_status = step.to_s
    render_wizard
  end

  def update
    @student_application.attributes = params[:student_application]

    render_wizard @student_application
    session[:student_application] = @student_application.id 
  end

  def project_sessions
    @projects_sessions = ProjectSession.where(project_id: params[:project])
    @projects_sessions.map! { |project| {id: project.id, text: project.select_label}}
    respond_to do |format|
      format.json { render :json => @projects_sessions }
    end
  end

  private

  def current_student_application
    @current_student_application ||= begin
      student_application = session[:student_application] && StudentApplication.find(session[:student_application])
      student_application ||= StudentApplication.new
    end
  end

  def set_student_application
    @student_application = current_student_application
  end

  def update_wizard_status
    params[:student_application][:wizard_status] = (next_step.to_s == steps.last.to_s ? 'complete' : next_step.to_s) 
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