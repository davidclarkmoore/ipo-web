class DonationsController < ApplicationController

  def create
    result = Braintree::Transaction.sale(
      :amount => params[:amount],
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
      flash[:error] = "<h1>Error: #{result.message}</h1>"
      render action: "new"
    end
  end

end
