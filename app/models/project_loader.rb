class ProjectLoader

	def self.load_projects(properties)
		return Project.scoped if properties.nil?
		projects = []

		properties.each do |key, value|
			projects.concat(related_to_properties?(key, value))
		end
		Project.where(id: projects)
	end

	def self.related_to_properties?(type, properties)
		projects = []
		Project.all.each do |project|	
			fields = get_clean_properties(project, type)
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