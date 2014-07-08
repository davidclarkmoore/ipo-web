class DonationProcessor

  def initialize(params)
    @params = params
  end

  def spot_reservation?
    @params[:donation][:student_application_id].present?
  end

  def student_donation?
    @params[:donation][:student_id].present?
  end

  def get_subscription(id)
    @subscription ||= Braintree::Subscription.find(id)
  end

  def get_customer(id)
    customer_id = get_subscription(id).transactions[0].customer_details.id
    customer = Braintree::Customer.find(customer_id)
  end

  def get_student_id
    student = Student.find(@params[:donation][:student_id]) if student_donation?
    student ? student.id : nil  
  end

  def update_donation_amount
    @params[:donation][:amount] = @params[:custom_amount] if @params[:custom_amount].present?
    @params[:donation][:amount] = Donation::SPOT_PRICE if spot_reservation?
    @params[:donation][:amount]
  end

  def process_donation
    student_id = get_student_id
    update_donation_amount
    result = nil
    if recurring?
      result = create_customer
      customer = result.customer if result.success?
      result = recurring_donation(customer, @params[:donation][:amount], student_id) if result.success?
      DonationMailer.donation_info_email( customer, result.subscription).deliver if result.success?
    else
      result = one_time_donation(student_id) 
    end
    if result.success? && spot_reservation?
      StudentApplication.find(@params[:donation][:student_application_id]).update_attribute(:reserved_his_spot, true)
    end
    result
  end

  def create_customer
    result = Braintree::Customer.create(
      first_name: @params[:customer][:first_name],
      last_name: @params[:customer][:last_name],
      email: @params[:customer][:email],
      credit_card: {
        number: @params[:card][:number],
        expiration_month: @params[:card][:expiration_month],
        expiration_year: @params[:card][:expiration_year],
        cvv: @params[:card][:cvv],
        billing_address: @params[:billing]
      }
    )
  end

  def one_time_donation (student_id = nil)
    result = Braintree::Transaction.sale(
      :amount => @params[:donation][:amount],
      :credit_card => @params[:card],
      :customer => @params[:customer],
      :billing => @params[:billing],
      :options => {
        :store_in_vault => true,
        :add_billing_address_to_payment_method => true,
        :submit_for_settlement => true
      }
    )
    Donation.create(amount: @params[:donation][:amount], 
      transcation_id: result.transaction.id, recurring: false, 
      student_id: student_id, status: Donation::SUBMITTED ) if result.success?
    result
  end

  def recurring?
    @params[:donation][:recurring] == "1"
  end

  def recurring_donation (customer, amount, student_id = nil)
    customer = Braintree::Customer.find(customer.id)
    payment_method_token = customer.credit_cards[0].token
    result = Braintree::Subscription.create(
      :payment_method_token => payment_method_token,
      :plan_id => "donation",
      :price => amount
    )
    Donation.create( amount: amount, customer_id: customer.id, 
      subscription_id: result.subscription.id, recurring: true,
      student_id: student_id, status: Donation::ACTIVE ) if result.success?
    result
  end

  def cancel_recurring_donation(subscription_id)
    subscription = get_subscription(subscription_id)
    if subscription 
      Braintree::Subscription.cancel(subscription.id) unless subscription.canceled?
    end
    subscription
  end

  Braintree::Subscription.class_eval do
    def canceled?
      status == Braintree::Subscription::Status::Canceled
    end
  end
  
end