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
      create_list(:completed_projects, total)
      
      get :index    
      expect(assigns(:total_projects)).to eq(total)
    end

    describe "Search projects" do
      context "Using name" do
        before(:each) do
          @total = rand(1..10)
          create_list(:completed_projects, rand(1..10))
          create_list(:projects_with_static_name, @total)
        end

        it "should return only projects that match" do
          get :index, q: {"name_cont"=>"project"}
          expect(assigns(:total_projects)).to eq(@total)
        end

        it "should return nothing if no project match" do 
          get :index, q: {"name_cont" => "asdfg"}
          expect(assigns(:total_projects)).to eq(0)
        end
      end

      context "Using team mode" do
        before(:each) do
          @total_individual = rand(1..10)
          create_list(:completed_projects, rand(1..10))
          create_list(:individual_projects, @total_individual)
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

      context "Using session timeframe" do
        before(:each) do
          @total = rand(1..10)
          create_list(:completed_projects, rand(1..10), created_at: Date.tomorrow)
          create_list(:completed_projects, @total, created_at: Date.today - 1.month)
        end

        it "should return projects in a range of dates" do
          created_at_gt = (Date.today - 1.month).strftime("%Y/%m/%d")
          created_at_lt = (Date.today).strftime("%Y/%m/%d")
          get :index, q: {"created_at_gt"=> created_at_gt, "created_at_lt"=>created_at_lt}
          expect(assigns(:total_projects)).to eq(@total)
        end

        it "should return nothing if no project is created in the specified interval" do
          created_at_gt = (Date.today + 1.month).strftime("%Y/%m/%d")
          get :index, q: {"created_at_gt" => created_at_gt}
          expect(assigns(:total_projects)).to eq(0)
        end
      end

      context "Using fields of study" do
        before(:each) do
          @total = rand(1..10)
          projects = create_list(:completed_projects, @total)
          create_list(:completed_projects, rand(1..10))
          fields = "[\"English\", \"Web Design\", \"Psychology\"]"
          set_different_fields_of_study(projects, fields)
        end

        it "should return projects that contain the related field of study" do
          get :index, properties: {"fields"=>["Web Design"]}
          expect(assigns(:total_projects)).to eq(@total)
        end
      end
      context "Using fields by passion"
      context "Using mixing filters"
    end
  end

  def set_different_fields_of_study(projects, fields_of_study)
    projects.each do |project|
      project.properties.merge!("related_fields_of_study" => fields_of_study)
      project.save
    end
  end
end