class OrganizationsController < ApplicationController

  def index

  end

  def show
    @o = Organization.find(params[:id])

    @projects = Project.where organization_id: @o.id

  end

  def new
    @o = Organization.new

    respond_to do |format|
      format.html  # new.html.erb
      format.json  { render :json => @o }
    end
  end

  def create
    org = Organization.new(params[:organization])
    org.save
    redirect_to :organizations
  end

  def edit
    @o = Organization.find(params[:id])
  end

  def update

  	org = Organization.find params[:id]

		if org.update_attributes params[:post]
		redirect_to organization_path
		else
		redirect_to :organizations
		end
  end

end
