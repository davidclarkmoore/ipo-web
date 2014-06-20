class DonationsController < ApplicationController

  def show
    @subscription = Braintree::Subscription.find(params[:id])
  end

  def new
    define_amounts
    subscription_id = params[:id]
    student_id = params[:student_id]
    if subscription_id.present? 
      @subscription = Braintree::Subscription.find(params[:id])
      customer_id = @subscription.transactions[0].customer_details.id
      @customer = Braintree::Customer.find(customer_id)
    elsif student_id.present? 
      @student = Student.find(student_id)
    end
  end

  def create
    params[:donation][:amount] = params[:custom_amount] if params[:custom_amount].present?
    student_id = params[:donation][:student_id] 
    result = make_donation(params[:donation][:amount], student_id)
    if result.success? 
      flash.now[:notice] = 'Thanks for your donation!'
      render action: "show"
    else
      define_amounts
      @student = Student.find(student_id) if student_id.present?
      flash[:error] = "Error: #{result.message}"
      render action: "new"
    end
  end

  def destroy
    @subscription = Braintree::Subscription.find(params[:id])
    Braintree::Subscription.cancel(@subscription.id) unless @subscription.status == Donation::CANCELED
    Donation.find_by_subscription_id(@subscription.id).update_attribute(:status, Donation::CANCELED)
    flash.now[:notice] = 'Your recurring donation has been canceled!'
    redirect_to action: "show", id: @subscription.id
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
  end

  def recurring?
    params[:donation][:recurring] == "1"
  end

  def make_donation(amount, student_id = nil )
    result = nil
    if recurring?
      result = create_customer
      customer = result.customer if result.success?
      result = recurrent_donation(customer, amount, student_id) if result.success?
      DonationMailer.donation_info_email( customer, result.subscription).deliver if result.success?
    else
      result = one_time_donation(student_id) 
    end
    result
  end
  
  def create_customer
    result = Braintree::Customer.create(
      first_name: params[:customer][:first_name],
      last_name: params[:customer][:last_name],
      email: params[:customer][:email],
      credit_card: {
        number: params[:card][:number],
        expiration_month: params[:card][:expiration_month],
        expiration_year: params[:card][:expiration_year],
        cvv: params[:card][:cvv],
        billing_address: params[:billing]
      }
    )
  end
  
  def one_time_donation (student_id = nil)
    result = Braintree::Transaction.sale(
      :amount => params[:donation][:amount],
      :credit_card => params[:card],
      :customer => params[:customer],
      :billing => params[:billing],
      :options => {
        :store_in_vault => true,
        :add_billing_address_to_payment_method => true,
        :submit_for_settlement => true
      }
    )
    Donation.create(amount: params[:donation][:amount], 
      transcation_id: result.transaction.id, recurring: false, 
      student_id: student_id, status: Donation::SUBMITTED ) if result.success?
    result
  end

  def recurrent_donation (customer, amount, student_id = nil)
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

end
