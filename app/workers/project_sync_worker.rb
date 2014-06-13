class ProjectSyncWorker
  include Sidekiq::Worker

  sidekiq_options retry: false
  sidekiq_options queue: "projects"

  def perform(project_id)
    begin 
      project = Project.find(project_id)
      project.save_to_sf!
    rescue Databasedotcom::SalesForceError => e
      message = "Salesforce syncrhonization error saving Project Application"
      Rails.logger.warn "#{message} #{project_id}: #{e.message}"
      SalesforceSyncFailureMailer.failure_details_email(
        message, e.message, project_id).deliver
      raise e
    end
  end

end