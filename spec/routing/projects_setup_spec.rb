require 'spec_helper'

describe "routing to project setup controller" do
  it "routes /projects/setup to projects_setup#index" do
    expect(:get => "/projects/setup").to route_to(
      :controller => "projects_setup",
      :action => "index")
  end
end
  