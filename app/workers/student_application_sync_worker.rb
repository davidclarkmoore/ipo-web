
class StudentApplicationSyncWorker
  include Sidekiq::Worker

  sidekiq_options retry: false
  sidekiq_options queue: "student_applications"

  def perform(student_application_id)
    student_application = StudentApplication.find(student_application_id)
    student_application.save_to_sf!
  end
end
