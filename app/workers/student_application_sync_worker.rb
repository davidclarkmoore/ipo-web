class StudentApplicationSyncWorker
  include Sidekiq::Worker

  sidekiq_options retry: false
  sidekiq_options queue: "student_applications"

  def perform(student_application_id)
    begin
      student_application = StudentApplication.find(student_application_id)
      student_application.save_to_sf!
    rescue Databasedotcom::SalesForceError => e
      message = "Salesforce syncrhonization error saving Student Application"
      Rails.logger.warn "#{message} #{student_application_id}: #{e.message}"
      SalesforceSyncFailureMailer.failure_details_email(
        message, e.message, student_application_id).deliver
      raise e
    end
  end
end