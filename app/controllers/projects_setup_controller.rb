class ProjectsSetupController < ApplicationController
  include Wicked::Wizard
  steps :about_you, :the_project, :location, :content, :agreement, :confirmation

  def show
    render_wizard
  end
end
