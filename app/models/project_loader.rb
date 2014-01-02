class ProjectLoader

	def self.load_projects(properties)
		return Project.scoped if properties.nil?
		#Temporal meanwhile the fields_of_study and/or and the student_passions are not sent in array syntax
		properties.each do |key, value|
			properties[key] = value.split
			properties.except!(key) if properties[key].blank?
		end
		Project.where.overlap(properties.symbolize_keys)
	end
end