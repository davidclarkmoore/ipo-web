require 'spec_helper'

describe DonationsController do

  def build_donation 
    { amount: 15, recurring: false } 
  end

  def build_recurrent_donation
    { amount: 15, recurring: true } 
  end

  def build_customer
    { first_name: "John", last_name: "Doe", 
      email: "john.doe@etherpros.com", phone: "12341234" }
  end

  def build_billing
    { street_address: "test address", postal_code: "10001"}
  end

  def build_card
    { number: "4111111111111111", cvv: "123", 
      expiration_month: '03', expiration_year: '04' }
  end

  def build_transaction
    { donation: build_donation, 
      customer: build_customer,
      billing:  build_billing,
      card: build_card }
  end

  def build_recurrent_transaction
    { donation: build_recurrent_donation, 
      customer: build_customer,
      billing:  build_billing,
      card: build_card }
  end

  describe "GET 'new'" do
    it "renders the new view" do
      get :new
      response.should render_template :new
    end
  end

  describe "POST 'create'" do
    def do_post(transaction, template)
      post :create, transaction
      response.should render_template template
    end
    
    context "with a one time transaction" do
      it "render the 'show' page when valid" do
        do_post build_transaction, :show
      end
      it "renders the form 'new' when the card is declined!" do
        FakeBraintree.decline_all_cards!
        do_post build_transaction, :new
      end
    end

    context "with a recurrent transaction" do  
      it "render the 'show' page when valid" do
        do_post build_recurrent_transaction, :show
      end

      it "renders the form 'new' when the card is declined!" do
        FakeBraintree.decline_all_cards!
        do_post build_recurrent_transaction, :new
      end
    end
  end

end