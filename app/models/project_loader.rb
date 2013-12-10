class ProjectLoader

	def self.load_projects(properties)
		return Project.scoped if properties.nil?

		projects = []
		if properties.has_key?("fields")
			projects.concat(related_to_properties?(properties["fields"], "fields"))
		elsif properties.has_key?("passions")
			projects.concat(related_to_properties?(properties["passions"], "passions"))
		end
		Project.where(id: projects)
	end

	def self.related_to_properties?(properties, type)
		projects = []
		Project.all.each do |project|
			project_properties = (type == "fields" ? "related_fields_of_study" : "related_student_passions")
			fields = get_clean_properties(project, project_properties)
			projects << project.id unless (fields & properties).empty?
		end
		projects
	end

	def self.get_clean_properties(project, project_properties)
		fields = []
		project.properties[project_properties].split(",").each do |field|
			fields << field.delete('[]""').strip
		end
		fields
	end
end