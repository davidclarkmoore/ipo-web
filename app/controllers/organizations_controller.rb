class OrganizationsController < ApplicationController

  def index
    @o = Organization.find(params[:id])
  end

  def show
    @o = Organization.find(params[:id])

  end

end
