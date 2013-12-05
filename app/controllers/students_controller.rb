class StudentsController < ApplicationController
  load_and_authorize_resource
  respond_to :html, :js
 
  def index
    @students = Student.all
  end

  def new
    @student = Student.new
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])
    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to student_path(@student), notice: 'Student updated successfully!' }
      else
        format.html { redirect_to :back, alert: @student.errors.full_messages}
        format.html { render :action => "edit" }
      end
    end
  end

  def create
    @student = Student.new(params[:student])
    flash[:notice] = "Student was successfully created." if @student.save
    
    respond_with(@student) do |format|
      format.html { redirect_to students_path }
    end
  end

  def show
    @student = Student.find(params[:id])
  end
end
