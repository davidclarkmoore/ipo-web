require 'spec_helper'

describe ProjectsSetupController do

  before(:each) do
    signin
  end
  
  describe "GET 'index'" do
    it "redirects to first step" do
      get 'index'
      response.should redirect_to projects_setup_path('about_you')
    end
  end

  %w(about_you the_project location content 
    agreement confirmation).each do |step|
    describe "GET '#show #{step}'" do
      it "returns http success" do
        get :show, id: step
        response.should be_success
      end

      it 'renders the #{step} template' do
        get :show, id: step
        response.should render_template(step)
      end
    end
  end

  describe "GET 'application_deadline'" do
    before(:each) do
      @session = create(:session)
    end

    it "finds the requested session" do
      get :application_deadline, id: @session.id
      assigns(:session).should eq(@session)
    end

    it "should get a succesful response" do
      get :application_deadline, id: @session.id, format: :json
      response.should be_success
    end

    it "should return correct JSON" do
      get :application_deadline, id: @session.id, format: :json
      response.body.should eq(@session.application_deadline.to_json)
    end
  end

  describe "PUT '#update project step: about_you'" do
     
    it "creates a project by default" do
      expect {
        put :update, id: 'about_you', project: {}
      }.to change(Project, :count).by (1)
    end 

    it "creates a unique project" do
      expect {
        put :update, id: 'about_you', project: {}
      }.to change(Project, :count).by (1)
      expect {
        put :update, id: 'about_you', project: {}
      }.to change(Project, :count).by (0)
    end

    context "when valid attributes" do
      
      it "creates a field_host" do
        expect {
          put :update, id: 'about_you', 
          project: { 
            field_host_attributes: FactoryGirl.attributes_for(:field_host)
          }
        }.to change(FieldHost,:count).by(1)
      end

      it "creates an organization" do
        expect {
          put :update, id: 'about_you',
            project: { organization_attributes: FactoryGirl.attributes_for(:organization) },
            is_new_organization: "true" 
        }.to change(Organization,:count).by(1)
      end

      it "redirects to next step: the_project" do
        put :update, id: 'about_you', 
          project: FactoryGirl.attributes_for(:project_for_about_you_step), 
          is_new_organization: "true"
        response.should redirect_to subject.send(:wizard_path, :the_project)
      end

    end

    context "when invalid attributes" do
      it "does not create a field host" do
        expect {
          put :update, id: 'about_you',
            project: {
              field_host_attributes: FactoryGirl.attributes_for(:invalid_field_host) 
            }
        }.to_not change(FieldHost,:count)
      end

      it "does not create an organization" do
        expect {
          put :update, id: 'about_you',
            project: { organization_attributes: FactoryGirl.attributes_for(:invalid_organization) }, 
            is_new_organization: "true"
        }.to_not change(Organization,:count)
      end

      it "redirects to same step: about_you" do
        put :update, id: 'about_you', project: 
          FactoryGirl.attributes_for(:invalid_project_for_about_you_step), 
          is_new_organization: "true"
        response.should render_template("about_you")
      end
    end
  end

  describe "PUT '#update project step: the_project'" do

    context "when valid attributes" do
      it "updates project" do
        put :update, id: 'the_project', 
          project: FactoryGirl.attributes_for(:project_for_the_project_step)
        assigns(:project).name.should eq("Test project")
        assigns(:project).min_students.should eq("5")
        assigns(:project).max_students.should eq("10")
        assigns(:project).per_week_cost.should eq("50")
        assigns(:project).per_week_cost_final.should eq("1")
        #assigns(:project).required_languages.should =~ ["spanish", "english"]
        assigns(:project).related_student_passions.should =~ ["children_at_risk"]
        assigns(:project).related_fields_of_study.should =~ ["aviation", "business_and_management"]
        assigns(:project).student_educational_requirement.should eq("some_college")
      end

      it "redirects to next step: location" do
        put :update, id: 'the_project', 
          project: FactoryGirl.attributes_for(:project_for_the_project_step)
        response.should redirect_to subject.send(:wizard_path, :location)
      end
    end

    context "when invalid attributes" do
      it "does not update project" do
        put :update, id: 'the_project', 
          project: FactoryGirl.attributes_for(:invalid_project_for_the_project_step)
        assigns(:project).name.should eq(nil)
        assigns(:project).team_mode.should eq(nil)
      end

      it "redirects to same step: the_project" do
        put :update, id: 'the_project', 
          project: FactoryGirl.attributes_for(:invalid_project_for_the_project_step)
        response.should render_template("the_project")
      end
    end
  end

  describe "PUT '#update project step: location" do
    context "when valid attributes" do

      it "updates project" do
        put :update, id: 'location',
          project: FactoryGirl.attributes_for(:project_for_location_step)
        assigns(:project).location_private.should eq(false)
        assigns(:project).address.should eq("street address")
        assigns(:project).internet_distance.should eq("on_site_free")
        assigns(:project).location_type.should eq("urban")
        #assigns(:project).transportation_available.should =~ ["private_team_vehicle"]
        assigns(:project).location_description.should eq("describe your city/area")
        assigns(:project).culture_description.should eq("describe the culture of the area")
      end

      it "redirects to next step: content" do
        put :update, id: 'location', 
          project: FactoryGirl.attributes_for(:project_for_location_step)
        response.should redirect_to subject.send(:wizard_path, :content)
      end
    end

    context "when invalid attributes" do

      it "does not update project" do
        put :update, id: 'the_project', 
          project: FactoryGirl.attributes_for(:invalid_project_for_location_step)
        assigns(:project).location_private.should eq(nil)
        assigns(:project).address.should eq(nil)
      end

      it "redirects to same step: location" do
        put :update, id: 'location', 
          project: FactoryGirl.attributes_for(:invalid_project_for_location_step)
        response.should render_template("location")
      end
    end
  end

  describe "PUT '#update project step: content" do
    context "when valid attributes" do

      it "updates project" do
        put :update, id: 'content',
          project: FactoryGirl.attributes_for(:project_for_content_step)
        assigns(:project).description.should eq("project description")
        assigns(:project).housing_type.should eq("dormitory")
        assigns(:project).dining_location.should eq("cafeteria")
        assigns(:project).housing_description.should eq("housing description")
        assigns(:project).safety_level.should eq("never_walk_alone")
        assigns(:project).challenges_description.should eq("challenges description")
        assigns(:project).typical_attire.should eq("very_modest")
        assigns(:project).guidelines_description.should eq("guidelines description")
      end

      it "redirects to next step: agreement" do
        put :update, id: 'content', 
          project: FactoryGirl.attributes_for(:project_for_content_step)
        response.should redirect_to subject.send(:wizard_path, :agreement)
      end
    end

    context "when invalid attributes" do

      it "does not update project" do
        put :update, id: 'content', 
          project: FactoryGirl.attributes_for(:invalid_project_for_content_step)
        assigns(:project).description.should eq(nil)
        assigns(:project).housing_description.should eq("")
        assigns(:project).challenges_description.should eq("")
      end

      it "redirects to same step: content" do
        put :update, id: 'content', 
          project: FactoryGirl.attributes_for(:invalid_project_for_content_step)
        response.should render_template("content")
      end
    end
  end

  describe "PUT '#update project step: agreement" do
    context "when valid attributes" do

      it "updates project" do
        put :update, id: 'agreement',
          project: FactoryGirl.attributes_for(:project_for_agreement_step)
        assigns(:project).agree_memo.should eq("1")
        assigns(:project).agree_to_transport.should eq("1")
      end

      it "redirects to next step: confirmation" do
        put :update, id: 'agreement', 
          project: FactoryGirl.attributes_for(:project_for_agreement_step)
        response.should redirect_to subject.send(:wizard_path, :confirmation)
      end
    end

    context "when invalid attributes" do

      it "does not update project" do
        put :update, id: 'agreement', 
          project: FactoryGirl.attributes_for(:invalid_project_for_agreement_step)
        assigns(:project).agree_memo.should eq("0")
        assigns(:project).agree_to_transport.should eq("0")
      end

      it "redirects to same step: agreement" do
        put :update, id: 'agreement', 
          project: FactoryGirl.attributes_for(:invalid_project_for_agreement_step)
        response.should render_template("agreement")
      end
    end
  end

end