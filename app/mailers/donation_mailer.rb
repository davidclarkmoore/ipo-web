class DonationMailer < ActionMailer::Base
  default from: "no-reply@converge.com"

  def donation_info_email(customer, subscription)
    @customer = customer
    @subscription = subscription
    mail(to: @customer.email, subject: 'Thanks for your donation!')
  end
end