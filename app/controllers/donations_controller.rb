class DonationsController < ApplicationController

  def new
    define_amounts
  end

  def create
    params[:donation][:amount] = params[:custom_amount] if params[:donation][:amount] == "other"
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
    if result.success?
      render action: "show" , notice: 'Thanks for donate!'
    else
      define_amounts
      flash[:error] = "Error: #{result.message}"
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
      ["$500","500"],
      ["$ other amount","other"]
    ]
  end

end
