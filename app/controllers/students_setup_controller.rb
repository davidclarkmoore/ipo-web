class StudentsSetupController < ApplicationController
  include Wicked::Wizard  
  steps :about_you, :interests_and_fields_of_study, :important_details, :confirmation
  before_filter :set_current_student_and_student_application, :clean_select_multiple_params
  before_filter :update_wizard_status, only: :update

  def show
    case step
    when :about_you
      @student.build_login unless @student.login
    when :interests_and_fields_of_study
      @student.build_spiritual_reference unless @student.spiritual_reference
      @student.build_academic_reference unless @student.academic_reference
    end
    @student.wizard_status = step.to_s
    render_wizard
  end

  def update
    @student.attributes = params[:student]
    case step
    when :about_you
      session[:project_session] = params[:student][:student_applications_attributes]["0"]["project_session_id"]
    end  
    
    render_wizard @student
    session[:student_id] = @student.id 
  end

  def project_sessions
    @projects_sessions = ProjectSession.where(project_id: params[:project])
    @projects_sessions.map! { |project| {id: project.id, text: project.select_label}}
    respond_to do |format|
      format.json { render :json => @projects_sessions }
    end
  end

  private

  def current_student
    @current_student ||= begin
      student = session[:student_id] && Student.find(session[:student_id])
      student ||= Student.new
    end
  end

  def current_student_application
    @student.student_applications.find_by_project_session_id(session[:project_session].to_i)
  end

  def set_current_student_and_student_application
    @student = current_student
    @current_student_application = current_student_application unless step == :about_you
  end

  def update_wizard_status
    params[:student][:wizard_status] = (next_step.to_s == steps.last.to_s ? 'complete' : next_step.to_s) 
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