Refinery::PagesController.class_eval do
    
    before_filter :fill_fields_of_study_and_passion_areas, :only => [:show]

	protected

		def fill_fields_of_study_and_passion_areas
			@fields_of_study = Project.related_fields_of_study.values
    		@student_passions = Project.related_student_passions.values
    	end

end