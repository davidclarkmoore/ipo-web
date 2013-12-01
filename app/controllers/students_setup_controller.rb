class StudentsSetupController < ApplicationController
  include Wicked::Wizard
  steps :about_you, :interests_and_fields_of_study, :important_details, :confirmation

  before_filter :check_step
  before_filter :clean_select_multiple_params

  def show
    @student = current_student
    case step
    when :about_you
      @student.email = @student.customer.email if @student.customer
    when :interests_and_fields_of_study
      @student.build_spiritual_reference unless @student.spiritual_reference
      @student.build_academic_reference unless @student.academic_reference
    end
    @student.wizard_status = step.to_s # For client-side validations
    render_wizard
  end

  def update
    @student = current_student

    case step
    when :about_you
      if !(@student.customer && @student.customer.id)
        @student.build_customer
      end
    when :interests_and_fields_of_study
      @student.build_spiritual_reference unless @student.spiritual_reference
      @student.build_academic_reference unless @student.academic_reference
    end

    params[:student][:wizard_status] = step.to_s
    params[:student][:wizard_status] = 'complete' if step == steps.last

    #This is saving two times, one here and another in render_wizard
    @student.update_attributes params[:student]

    render_wizard @student
    session[:student_id] = @student.id
  end

  private
  def current_student
    @current_student ||= begin
      student = session[:student_id] && Student.find_by_id(session[:student_id])
      student ||= Student.new
    end
  end
  def check_step
    # TODO: Add a validation to make sure user isn't skipping ahead
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
