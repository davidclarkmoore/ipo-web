class ProjectLoader

  def self.load_projects(properties)
    return Project.scoped if properties.nil?
    
    Project.where.overlap(properties.symbolize_keys)
  end
end