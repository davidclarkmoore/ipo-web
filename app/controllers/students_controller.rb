class StudentsController < ApplicationController
  load_and_authorize_resource
  respond_to :html, :js
 
  def index
    @students = Student.all
  end

  def new
    @student = Student.new
  end

  def create
    @student = student.new(params[:student])
    flash[:notice] = "Student was successfully created." if @student.save
    
    respond_with(@student) do |format|
      format.html { redirect_to students_path }
    end
  end

end
