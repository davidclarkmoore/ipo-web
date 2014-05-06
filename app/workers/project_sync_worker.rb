class ProjectSyncWorker
  include Sidekiq::Worker

  sidekiq_options retry: false
  sidekiq_options queue: "projects"

  def perform(project_id)
    project = Project.find(project_id)
    project.save_to_sf!
  end

end