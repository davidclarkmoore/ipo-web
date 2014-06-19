class DonationsController < ApplicationController

  def show
    @subscription = Braintree::Subscription.find(params[:id])
  end

  def new
    define_amounts
    subscription_id = params[:id]
    if subscription_id.present? 
      @subscription = Braintree::Subscription.find(params[:id])
      customer_id = @subscription.transactions[0].customer_details.id
      @customer = Braintree::Customer.find(customer_id)
    end
  end

  def create
    params[:donation][:amount] = params[:custom_amount] if params[:custom_amount].present? 
    result = make_donation(params[:donation][:amount])
    if result.success? 
      flash.now[:notice] = 'Thanks for your donation!'
      render action: "show"
    else
      define_amounts
      flash.now[:error] = "Error: #{result.message}"
      render action: "new"
    end
  end

  def destroy
    @subscription = Braintree::Subscription.find(params[:id])
    Braintree::Subscription.cancel(@subscription.id) unless @subscription.status == "Canceled"
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

  def make_donation(amount)
    result = nil
    if recurring?
      result = create_customer
      customer = result.customer if result.success?
      result = recurrent_donation(customer, amount) if result.success?
      DonationMailer.donation_info_email( customer, result.subscription).deliver if result.success?
    else
      result = one_time_donation
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
  
  def one_time_donation
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
  end

  def recurrent_donation (customer, amount)
    customer = Braintree::Customer.find(customer.id)
    payment_method_token = customer.credit_cards[0].token
    result = Braintree::Subscription.create(
      :payment_method_token => payment_method_token,
      :plan_id => "donation",
      :price => amount
    )
  end

end
