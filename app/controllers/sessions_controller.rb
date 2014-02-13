class SessionsController < ApplicationController
  before_filter :authenticate_login!
  respond_to :html, :js

  def index
    @sessions = Session.order(:title)
  end

  def new
    @session = Session.new 
  end

  def create
    @session = Session.new(params[:session])
    if @session.save
      flash[:notice] = "Session created successfully"
      redirect_to sessions_path
    else
      render action: 'new'
    end
  end

  def show
    @session = Session.find(params[:id])
  end

  def edit
    @session = Session.find(params[:id])
  end

  def destroy
    @session = Session.find(params[:id])
    @session.destroy
    redirect_to :back, notice: "Session deleted successfully"
  end

  def update
    @session = Session.find(params[:id])
    if @session.update_attributes(params[:session])
      redirect_to sessions_path, notice: "Session updated successfully"
    else
      render action: 'edit'
    end
  end
end
