class StudentsSetupController < ApplicationController
  before_filter :current_student_application, :clean_select_multiple_params
  include Wicked::Wizard
  steps :about_you, :interests_and_fields_of_study, :important_details, :confirmation


  def show
    @student_application.build_student unless @student_application.student
    case step
    when :about_you
      # This is used for the apply button in project/show.html.haml
      @project_selected = Project.find(params[:project_id]) if params[:project_id]
      @student_application.student.build_login unless @student_application.student && @student_application.student.login
    when :interests_and_fields_of_study
      @academic_reference = PersonReference.find_or_build_person_reference(@student_application.person_references, :academic_reference)
      @spiritual_reference = PersonReference.find_or_build_person_reference(@student_application.person_references, :spiritual_reference)
      @new_academic_reference =  @student_application.person_references.build(reference_type: :academic_reference)
      @new_spiritual_reference = @student_application.person_references.build(reference_type: :spiritual_reference)
    end
    @student_application.wizard_status = step.to_s
    render_wizard
  end

  def update
    case step
    when :interests_and_fields_of_study
      remove_extra_attributes("spiritual_reference", params[:is_new_spiritual_reference])
      remove_extra_attributes("academic_reference", params[:is_new_academic_reference])
    end

    params[:student_application][:wizard_status] = step.to_s
    params[:student_application][:wizard_status] = 'complete' if step == :important_details

    @student_application.update_attributes params[:student_application]
    
    if step == :important_details
      # create/update SF object
      StudentApplicationSyncWorker.perform_async(@student_application.id)
    end

    create_login_session unless login_signed_in?
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

  def person_references_params
    student_params[:person_references_attributes]
  end

  def student_params
    params[:student_application][:student_attributes]
  end

  def current_student_application
    @student_application ||= begin
      student_application = session[:student_application] && StudentApplication.find(session[:student_application])
      student_application ||= associate_to_student
    end
  end

  def associate_to_student
    return StudentApplication.new unless current_student
    StudentApplication.new(student_id: current_student.id)
  end

  def create_login_session
    sign_in @student_application.student.login
  end

  def clean_select_multiple_params hash = params
    hash.each do |k, v|
      case v
      when Array then v.reject!(&:blank?)
      when Hash then clean_select_multiple_params(v)
      end
    end
  end

  def remove_extra_attributes(reference, value)
    if value == "true"
      person_references_params.reject! { |k, v| !v['reference_id'].nil? && v['reference_type'] == reference }
    else
      person_references_params.reject! { |k, v| v['reference_id'].blank? && v['reference_type'] == reference }
    end
  end
end