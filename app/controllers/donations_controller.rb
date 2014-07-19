class DonationsController < ApplicationController
  before_filter :create_donation_processor

  def show
    @subscription = @donation_processor.get_subscription(params[:id])
    donation = Donation.find_by_subscription_id(@subscription.id)
    @student = Student.find(donation.student_id) if donation && donation.student_id
  end

  def new
    define_amounts
    if params[:subscription_id].present?  #renew existing donation
      @subscription = @donation_processor.get_subscription(params[:subscription_id])
      @customer = @donation_processor.get_customer(params[:subscription_id])
    elsif params[:student_id].present?  #donation for a specific student
      @student = Student.find(params[:student_id])
    elsif params[:student_application_id].present? #donation to reserve an spot
      @student = current_student if current_student
      @student_application_id = params[:student_application_id]
      flash.now[:notice] = 'Reserve My Spot for $25!'
      render action: "new"
    end
    #else donation for the whole project no action needed
  end

  def create
    result = @donation_processor.process_donation
    if result.success? 
      if @donation_processor.spot_reservation?

        # TODO: Refactor this code to somewhere else.
        student_application = StudentApplication.find(params[:donation][:student_application_id])
        student_application.set_to_reserved!
        StudentApplicationSyncWorker.perform_async(student_application.id) # Push change to salesforce.

        redirect_to dashboards_path(view: 'profile_page') and return 
      end
      flash.now[:notice] = 'Thanks for your donation!'
      render action: "show"
    else
      define_amounts unless @donation_processor.spot_reservation?
      flash[:error] = "Error: #{result.message}"
      render action: "new"
    end
  end

  def destroy
    subscription = @donation_processor.cancel_recurring_donation(params[:id])
    Donation.find_by_subscription_id(subscription.id).update_attribute(:status, Donation::CANCELED)
    flash.now[:notice] = 'Your recurring donation has been canceled!'
    redirect_to action: "show", id: subscription.id
  end

  private

  def define_amounts
    @amounts = [
      ["$10", "10"],
      ["$35","35"],
      ["$50","50"],
      ["$100","100"],
      ["$250","250"],
      ["$500","500"]
    ]
    @amounts = nil if params[:student_application_id].present?
  end

  def create_donation_processor 
    @donation_processor = DonationProcessor.new(params)
  end

end
