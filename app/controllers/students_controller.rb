class StudentsController < ApplicationController
  respond_to :html, :js

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(params[:student])
    if @student.save
      redirect_to students_path, notice: "Student was created successfully"
    else
      render :new
    end
  end
  
  def show
    @student = Student.find(params[:id])
  end
  
  def donate
    @student = Student.find(params[:student_id])
  end
  
  def donating
    @student = Student.find(params[:student_id])
    puts params.inspect
    
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
    puts result.inspect
    if result.success?
      redirect_to @student, notice: 'Thanks for donate!'
    else
      flash[:error] = "<h1>Error: #{result.message}</h1>"
      render :donate
    end
  end

  def apply
    begin 
      client = SFRails.connection 
      client.materialize('Lead')
      apply = params[:apply]
      @lead = Lead.create( "FirstName" => apply[:first_name],
        "LastName" => apply[:last_name], "Email" => apply[:email],
        "Company" => "None" );
    rescue Databasedotcom::SalesForceError => e
      Rails.logger.warn "SalesForceError creting a Lead: #{e.message}"
    end
    respond_to do |format|
      format.js
    end
  end
  
end
