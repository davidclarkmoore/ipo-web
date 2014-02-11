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
end
