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
          create_list(:completed_projects, rand(1..10))
          @total = rand(1..10)
          projects = create_list(:completed_projects, @total) 
          fields = "[\"English\", \"Web Design\", \"Psychology\"]"
          set_different_properties(projects, "related_fields_of_study", fields)
        end

        it "should return related projects to the field of study" do
          get :index, properties: {"related_fields_of_study"=>["Web Design"]}
          expect(assigns(:total_projects)).to eq(@total)
        end

        it "shouldn't return misrelated projects to the field of study" do
          get :index, properties: {"related_fields_of_study" => ["Aviation"]}
          expect(assigns(:total_projects)).to eq(Project.all.count - @total)
        end

        it "should return all the projects" do
          get :index, properties: {"related_fields_of_study" => ["Web Design", "Aviation"]}
          expect(assigns(:total_projects)).to eq(Project.all.count)
        end

      end
      context "Using fields by passion" do
        before(:each) do
          @total = rand(1..10)
          create_list(:completed_projects, rand(1..10))
          projects = create_list(:completed_projects, @total)     
          fields = "[\"Children at Risk\", \"Malaria Prevention\"]" 
          set_different_properties(projects, "related_student_passions", fields)
        end
 
        it "should return related projects to the student passions" do
          get :index, properties: {"related_student_passions" => ["Malaria Prevention"]}
          expect(assigns(:total_projects)).to eq(@total)
        end

        it "shouldn't return misrelated projects to the student passions" do
          get :index, properties: {"related_student_passions" => ["Poverty"]}
          expect(assigns(:total_projects)).to eq(Project.all.count - @total)
        end

        it "should return all the projects" do
          get :index, properties: {"related_student_passions" => ["Malaria Prevention", "Poverty"]}
          expect(assigns(:total_projects)).to eq(Project.all.count)
        end
      end

      context "Using mixed filters" do
        before(:each) do
          create_list(:completed_projects, rand(1..10))
          create_list(:individual_projects, rand(1..10))
          create_list(:projects_with_static_name, rand(1..10))         
       end

        it "should return individual projects related to Malaria" do
          individual_projects = rand(1..10)
          projects = create_list(:individual_projects, individual_projects)
          passions = "[\"Malaria Prevention\"]" 
          set_different_properties(projects, "related_student_passions", passions)
          get :index, q: { "team_mode_true"=>"0", "team_mode_false"=>"1"}, properties: {"related_student_passions"=>["Malaria Prevention"]}
          expect(assigns(:total_projects)).to eq(individual_projects)
        end

        it "should return projects related to Malaria Prevention and Web Design" do
          projects_related_to_malaria = rand(1..10)
          passions = "[\"Malaria Prevention\"]" 
          projects = create_list(:completed_projects, projects_related_to_malaria)
          set_different_properties(projects, "related_student_passions", passions)

          projects_related_to_web_design = rand(1..10)
          fields = "[\"Web Design\"]"
          projects2 = create_list(:completed_projects, projects_related_to_web_design)   
          set_different_properties(projects2, "related_fields_of_study", fields)

          get :index, properties: {"related_fields_of_study"=>["Web Design"], "related_student_passions"=>["Malaria Prevention"]}
          expect(assigns(:total_projects)).to eq(projects_related_to_web_design + projects_related_to_malaria)
        end


        it "should return projects created in a range of dates with a specific name" do
          projects = rand(1..10)
          created_at_gt = (Date.today - 1.month).strftime("%Y/%m/%d")
          created_at_lt = (Date.today).strftime("%Y/%m/%d")
          create_list(:projects_with_static_name, projects, created_at: Date.today - 1.month)

          get :index, q: { "name_cont" => "project", "created_at_gt"=> created_at_gt, "created_at_lt"=>created_at_lt}
          expect(assigns(:total_projects)).to eq(projects)
        end
      end
    end
  end

  def set_different_properties(projects, type, fields)
    projects.each do |project|
      project.properties.merge!(type => fields)
      project.save
    end
  end
end