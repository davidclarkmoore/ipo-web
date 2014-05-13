class DonationsController < ApplicationController

  def new
    define_amounts
  end

  def create
    params[:donation][:amount] = params[:custom_amount] if params[:custom_amount].present?
    if params[:donation][:recurring] == "1"
      result = recurrent_donation
    else
      result = one_time_donation
    end

    if result.success?
      render action: "show", notice: 'Thanks for your donation!'
    else
      define_amounts
      flash.now[:error] = "Error: #{result.message}"
      render action: "new"
    end
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

  def recurrent_donation
    result = Braintree::Customer.create(
      first_name: params[:customer][:first_name],
      last_name: params[:customer][:last_name],
      credit_card: {
        number: params[:card][:number],
        expiration_month: params[:card][:expiration_month],
        expiration_year: params[:card][:expiration_year],
        cvv: params[:card][:cvv],
        billing_address: params[:billing]
      }
    )
    if result.success?
      customer = Braintree::Customer.find(result.customer.id)
      payment_method_token = customer.credit_cards[0].token
      result = Braintree::Subscription.create(
        :payment_method_token => payment_method_token,
        :plan_id => "donation",
        :price => params[:donation][:amount]
      )
    end
    result
  end

end
