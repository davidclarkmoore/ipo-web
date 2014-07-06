class SalesforceSyncFailureMailer < ActionMailer::Base
  default from: "salesforce-sync-failure@converge.com"

  def failure_details_email(subject, error, object_id)
    @subject = subject
    @error = error
    @object_id = object_id
    mail(to: SF_API_CONFIG[:email_address], subject: subject)
  end
end
