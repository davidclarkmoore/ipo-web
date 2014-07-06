Refinery::PagesController.class_eval do
    
  before_filter :fill_fields_of_study_and_passion_areas, :only => [:home]

  protected

    def fill_fields_of_study_and_passion_areas
      @fields_of_study = Project.top_ten_fields_of_study
      @student_passions = Project.top_ten_student_passions
    end

end