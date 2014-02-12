require 'spec_helper'

describe ProjectsSetupController do

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

  describe "GET 'application_deadline'" do
    before(:each) do
      @session = FactoryGirl.create(:session)
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
end