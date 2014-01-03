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
      projects = create_list(:completed_projects, total)
      
      get :index    
      expect(assigns(:projects).result).to match_array(projects)
    end

    describe "Search projects" do
      context "Using name" do
        before(:each) do
          create_list(:completed_projects, rand(1..10))
          @projects = create_list(:projects_with_static_name, rand(1..10))
        end

        it "should return only projects that match" do
          get :index, q: {"name_cont"=>"project"}
          expect(assigns(:projects).result).to match_array(@projects)
        end

        it "should return nothing if no project match" do 
          get :index, q: {"name_cont" => "asdfg"}
          expect(assigns(:projects).result).to be_empty
        end
      end

      context "Using team mode" do
        before(:each) do
          @team_projects = create_list(:completed_projects, rand(1..10))
          @individual_projects = create_list(:individual_projects, rand(1..10))
        end

         it "should return only team projects" do
          get :index, q: {"team_mode_true" => 1}
          expect(assigns(:projects).result).to match_array(@team_projects)
         end

         it "should return only individual projects" do
          get :index, q: {"team_mode_true" => 0, "team_mode_false" => 1}
          expect(assigns(:projects).result).to match_array(@individual_projects)
         end
      end

      context "Using session timeframe" do
        before(:each) do
          create_list(:completed_projects, rand(1..10), created_at: Date.tomorrow)
          @projects = create_list(:completed_projects, rand(1..10), created_at: Date.today - 1.month)
        end

        it "should return projects in a range of dates" do
          created_at_gt = (Date.today - 1.month).strftime("%Y/%m/%d")
          created_at_lt = (Date.today).strftime("%Y/%m/%d")
          get :index, q: {"created_at_gt"=> created_at_gt, "created_at_lt"=>created_at_lt}
          expect(assigns(:projects).result).to eq(@projects)
        end

        it "should return nothing if no project is created in the specified interval" do
          created_at_gt = (Date.today + 1.month).strftime("%Y/%m/%d")
          get :index, q: {"created_at_gt" => created_at_gt}
          expect(assigns(:projects).result).to be_empty
        end
      end

      context "Using fields of study" do
        before(:each) do
          @projects = create_list(:projects_with_fields_of_study, rand(1..10))
          @projects_related = create_list(:projects_with_fields_of_study, rand(1..10)) 
          fields = ["english", "web_design", "psychology"]
          set_different_properties(@projects_related, "related_fields_of_study", fields)
        end

        it "should return related projects to the field of study" do
          get :index, properties: {"related_fields_of_study" => ["web_design"]}
          expect(assigns(:projects).result).to match_array(@projects_related)
        end

        it "shouldn't return misrelated projects to the field of study" do
          get :index, properties: {"related_fields_of_study" => ["aviation"]}
          expect(assigns(:projects).result).to match_array(@projects)
        end

        it "should return all the projects" do
          get :index, properties: {"related_fields_of_study" => ["web_design", "aviation"]}
          expect(assigns(:projects).result).to match_array(Project.all)
        end
      end

      context "Using fields by passion" do
        before(:each) do
          @projects = create_list(:projects_with_student_passions, rand(1..10))
          @projects_related = create_list(:projects_with_student_passions, rand(1..10))     
          fields = ["children_at_Risk", "malaria_prevention"] 
          set_different_properties(@projects_related, "related_student_passions", fields)
        end
 
        it "should return projects related to the student passions" do
          get :index, properties: {"related_student_passions" => ["malaria_prevention"]}
          expect(assigns(:projects).result).to match_array(@projects_related)
        end

        it "shouldn't return misrelated projects to the student passions" do
          get :index, properties: {"related_student_passions" => ["poverty"]}
          expect(assigns(:projects).result).to match_array(@projects)
        end

        it "should return all the projects" do
          get :index, properties: {"related_student_passions" => ["malaria_prevention", "poverty"]}
          expect(assigns(:projects).result).to match_array(Project.all)
        end
      end

      context "Using mixed filters" do
        before(:each) do
          create_list(:completed_projects, rand(1..10))
          create_list(:individual_projects, rand(1..10))
          create_list(:projects_with_static_name, rand(1..10))         
       end

        it "should return individual projects related to Malaria" do
          individual_projects = create_list(:individual_projects, rand(1..10))
          passions = ["malaria_prevention"] 
          individual_projects_with_student_passions = individual_projects.sample(rand(1..5))
          set_different_properties(individual_projects_with_student_passions, "related_student_passions", passions)
          get :index, q: { "team_mode_true"=>"0", "team_mode_false"=>"1"}, properties: {"related_student_passions"=>["malaria_prevention"]}
          expect(assigns(:projects).result).to match_array(individual_projects_with_student_passions)
        end

        it "should return projects related to Malaria Prevention and Web Design" do
          passions = ["malaria_prevention"] 
          projects_related_to_malaria = create_list(:completed_projects, rand(1..10))
          set_different_properties(projects_related_to_malaria, "related_student_passions", passions)

          fields = ["web_design"]
          projects_related_to_web_design_and_malaria = projects_related_to_malaria.sample(rand(1..5))  
          set_different_properties(projects_related_to_web_design_and_malaria, "related_fields_of_study", fields)

          get :index, properties: {"related_fields_of_study"=>["web_design"], "related_student_passions"=>["malaria_prevention"]}
          expect(assigns(:projects).result).to match_array(projects_related_to_web_design_and_malaria)
        end


        it "should return projects created in a range of dates with a specific name" do 
          projects = create_list(:projects_with_static_name, rand(1..10), created_at: Date.today - 1.month)

          created_at_gt = (Date.today - 1.month).strftime("%Y/%m/%d")
          created_at_lt = (Date.today - 1.day).strftime("%Y/%m/%d")          
          get :index, q: { "name_cont" => "project", "created_at_gt" => created_at_gt, "created_at_lt" => created_at_lt}
          expect(assigns(:projects).result).to match_array(projects)
        end
      end
    end
  end

  def set_different_properties(projects, type, fields)
    projects.each do |project|
      project.update_attribute(type.to_sym, fields)
    end
  end
end