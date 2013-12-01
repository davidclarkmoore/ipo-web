# coding: UTF-8

class CustomerSessionsController < ApplicationController
  def new
    @customer_session = CustomerSession.new
  end
  
  def create
    @customer_session = CustomerSession.new(params[:customer_session])
    if @customer_session.save
      flash[:notice] = "Welcome."

      if current_customer.is_student?
        session[:student_id] = current_customer.entity_id
        redirect_to "/students/setup/about_you"
      elsif current_customer.is_project_manager?
        session[:project_id] = current_customer.entity_id
      else
        redirect_to root_path
      end
    else
      flash[:error] = "Check your credentials."
      @customer_session = CustomerSession.new(params[:customer_session])
      render :action => 'new'
    end
  end
  
  def destroy
    @customer_session = CustomerSession.find
    @customer_session.destroy
    session[:student_id] = nil
    session[:project_id] = nil
    flash[:notice] = "Session closed."

    redirect_to root_path
  end
end
