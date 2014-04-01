Refinery::Pages::Admin::PreviewController.class_eval do
    
  before_filter :only => [:show] do |controller|
    fill_fields_of_study_and_passion_areas if controller.params[:page][:title] == "Home"
  end

  protected

    def fill_fields_of_study_and_passion_areas
      @fields_of_study = Project.related_fields_of_study.values
      @student_passions = Project.related_student_passions.values
    end

end