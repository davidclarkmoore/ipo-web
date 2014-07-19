class StudentsController < ApplicationController
  protect_from_forgery except: :sync_with_sf  
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

  def sync_with_sf
    begin
      sf_student_app = StudentApplication.sf.find_by_id(params[:sf_object_id])
      sf_student = Student.sf.find_by_id(sf_student_app.Contact__c) 
      ActiveRecord::Base.transaction do
        sf_student_app.save_to_rails!
        sf_student.save_to_rails!
      end
      render json: sf_student_app
    rescue => e
      render json: { error: e.message }, status: 400
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
