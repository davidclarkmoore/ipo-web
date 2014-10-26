require "spec_helper"

describe LessionsController do
  describe "routing" do

    it "routes to #index" do
      get("/lessions").should route_to("lessions#index")
    end

    it "routes to #new" do
      get("/lessions/new").should route_to("lessions#new")
    end

    it "routes to #show" do
      get("/lessions/1").should route_to("lessions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/lessions/1/edit").should route_to("lessions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/lessions").should route_to("lessions#create")
    end

    it "routes to #update" do
      put("/lessions/1").should route_to("lessions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/lessions/1").should route_to("lessions#destroy", :id => "1")
    end

  end
end
