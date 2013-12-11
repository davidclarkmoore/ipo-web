require 'spec_helper'

describe ProjectsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "renders the :index view" do
      get :index
      response.should render_template :index
    end

    it "returns all projects if no filter is used" do
      total = rand(1..10)
      FactoryGirl.create_list(:project, total, :complete)
      
      get :index    
      expect(assigns(:total_projects)).to eq(total)
    end

    describe "Search projects" do
      context "Using name" do
        before(:each) do
          @total = rand(1..10)
          FactoryGirl.create_list(:project, rand(1..10), :complete)
          FactoryGirl.create_list(:project, @total, :static_name, :complete)
        end

        it "should return only projects that match" do
          get :index, q: {"name_cont"=>"project"}
          expect(assigns(:total_projects)).to eq(@total)
        end

        it "should return nothing it no project match" do 
          get :index, q: {"name_cont" => "asdfg"}
          expect(assigns(:total_projects)).to eq(0)
        end
      end

      context "Using team mode" do
        before(:each) do
          @total_individual = rand(1..10)
          FactoryGirl.create_list(:project, rand(1..10), :complete)
          FactoryGirl.create_list(:project, @total_individual, :individual_mode, :complete)
        end

         it "should return only team projects" do
          get :index, q: {"team_mode_true" => 1}
          expect(assigns(:total_projects)).to eq(Project.all.count - @total_individual)
         end

         it "should return only individual projects" do
          get :index, q: {"team_mode_true" => 0, "team_mode_false" => 1}
          expect(assigns(:total_projects)).to eq(@total_individual)
         end
      end

      context "Using session"
      context "Using fields of study"
      context "Using fields by passion"
      context "Using mixing filters"
    end
  end

end
