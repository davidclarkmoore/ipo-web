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

  describe "GET '#show about_you'" do
    it "returns http success" do
      get :show, id: 'about_you'
      response.should be_success
    end

    it 'renders the about_you template' do
      get :show, id: 'about_you'
      response.should render_template("about_you")
    end
  end

  describe "GET #show the_project" do
    it "return http success" do
      get :show, id: 'the_project'
      response.should be_success
    end

    it "return the the_project template" do
      get :show, id: 'the_project'
      response.should render_template("the_project")
    end
  end

  describe "GET #show location" do
    it "return http success" do
      get :show, id: 'location'
      response.should be_success
    end

    it "return the location template" do
      get :show, id: 'location'
      response.should render_template("location")
    end
  end

  describe "GET #show content" do
    it "return http success" do
      get :show, id: 'content'
      response.should be_success
    end

    it "return the content template" do
      get :show, id: 'content'
      response.should render_template("content")
    end
  end

  describe "GET #show agreement" do
    it "return http success" do
      get :show, id: 'agreement'
      response.should be_success
    end

    it "return the agreement template" do
      get :show, id: 'agreement'
      response.should render_template("agreement")
    end
  end

  describe "GET #show confirmation" do
    it "return http success" do
      get :show, id: 'confirmation'
      response.should be_success
    end

    it "return the confirmation template" do
      get :show, id: 'confirmation'
      response.should render_template("confirmation")
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

  describe "PUT '#update about_you'" do
     
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
        put :update, id: 'about_you', project: {
          field_host_attributes: FactoryGirl.attributes_for(:field_host),
          organization_attributes: FactoryGirl.attributes_for(:organization)
        }, is_new_organization: "true"
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

      it "does not create a organization" do
        expect {
          put :update, id: 'about_you',
            project: { organization_attributes: FactoryGirl.attributes_for(:invalid_organization) }, 
            is_new_organization: "true"
        }.to_not change(FieldHost,:count)
      end

      it "redirects to same step: about_you" do
        put :update, id: 'about_you', project: {
          field_host_attributes: FactoryGirl.attributes_for(:invalid_field_host),
          organization_attributes: FactoryGirl.attributes_for(:invalid_organization)
        }, is_new_organization: "true"
        response.should render_template("about_you")
      end
    end
  end

end