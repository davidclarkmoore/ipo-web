class ProjectLoader

	def self.load_projects(properties)
		return Project.scoped if properties.nil?
		
		projects = []
		if properties.has_key?("fields")
			projects.concat(related_to_fields_of_study?(properties["fields"]))
		elsif properties.has_key?("passions")
			projects.concat(related_to_student_passions?(properties["passions"]))
		end
		Project.where(id: projects)
	end

	def self.related_to_fields_of_study?(study_values)
    projects = []
    Project.all.each do |project|
      field_of_studies = []
      project.properties["related_fields_of_study"].split(",").each do |field|
        field_of_studies << field.delete('[]""').strip
      end
      projects << project.id unless (field_of_studies & study_values).empty?
    end
    projects
  end

  def self.related_to_student_passions?(student_passion_values)
    projects = []
    Project.all.each do |project|
      student_passions = []
      project.properties["related_student_passions"].split(",").each do |field|
        student_passions << field.delete('[]""').strip
      end
      projects << project.id unless (student_passions & student_passion_values).empty?
    end
    projects
  end

end